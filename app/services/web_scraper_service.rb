# frozen_string_literal: true

require "open-uri"
require "nokogiri"

# Service responsible for scraping website data
# Extracts: title, description, emails, phones, social networks, address
class WebScraperService
  SOCIAL_NETWORK_PATTERNS = %w[facebook twitter instagram linkedin].freeze

  PHONE_PATTERN = /\b(?:\+?(?:\d{1,3})?[\s-]?\d{10}\b)/
  EMAIL_PATTERN = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i
  ADDRESS_PATTERN = /(?i)(?:CR|Cl|Diagonal|Transversal|Avenida|Carrera)\s*\d+\s*(?:#|No\.)\s*\d+(?:-\d+)?(?:\s*[^\d]+)?/

  attr_reader :url, :errors

  def initialize(url)
    @url = url
    @errors = []
  end

  def call
    scrape_website
  end

  def success?
    @errors.empty?
  end

  private

  def scrape_website
    document = fetch_document
    return empty_result if document.nil?

    {
      title: extract_title(document),
      description: extract_description(document),
      emails: extract_emails(document),
      phones: extract_phones(document),
      social_networks: extract_social_networks(document),
      website_url: @url,
      address: extract_address(document)
    }
  rescue StandardError => e
    @errors << "Error scraping #{@url}: #{e.message}"
    Rails.logger.error("WebScraperService error: #{e.message} for URL: #{@url}")
    empty_result
  end

  def fetch_document
    html = URI.open(@url, read_timeout: 30, open_timeout: 10).read
    Nokogiri::HTML(html)
  rescue OpenURI::HTTPError => e
    @errors << "HTTP Error: #{e.message}"
    nil
  rescue OpenSSL::SSL::SSLError => e
    @errors << "SSL Error: #{e.message}"
    nil
  rescue SocketError, Errno::ECONNREFUSED => e
    @errors << "Connection Error: #{e.message}"
    nil
  rescue Timeout::Error => e
    @errors << "Timeout Error: #{e.message}"
    nil
  end

  def extract_title(document)
    document.title&.strip
  end

  def extract_description(document)
    meta = document.at('meta[name="description"]')
    meta&.[]("content")&.strip
  end

  def extract_emails(document)
    document.text.scan(EMAIL_PATTERN).uniq
  end

  def extract_phones(document)
    document.text.scan(PHONE_PATTERN).uniq
  end

  def extract_social_networks(document)
    document.css("a[href]").filter_map do |link|
      href = link["href"]
      next unless href && social_network_url?(href)

      href
    end.uniq
  end

  def extract_address(document)
    matches = document.text.scan(ADDRESS_PATTERN)
    matches.first&.strip || ""
  end

  def social_network_url?(href)
    SOCIAL_NETWORK_PATTERNS.any? do |network|
      href =~ /^(http|https):\/\/(www\.)?#{network}\.com/
    end
  end

  def empty_result
    {
      title: nil,
      description: nil,
      emails: [],
      phones: [],
      social_networks: [],
      website_url: @url,
      address: nil
    }
  end
end
