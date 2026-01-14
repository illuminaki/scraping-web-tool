# frozen_string_literal: true

# Job to scrape a single website in the background
class ScrapeWebsiteJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform(register_id)
    register = Register.find_by(id: register_id)
    return unless register

    scraper = WebScraperService.new(register.url)
    result = scraper.call

    if scraper.success?
      update_register(register, result)
    else
      Rails.logger.error("Scraping failed for register #{register_id}: #{scraper.errors.join(', ')}")
    end
  end

  private

  def update_register(register, data)
    register.update!(
      title: data[:title],
      description: data[:description],
      emails: data[:emails]&.join(", "),
      phones: data[:phones]&.join(", "),
      social_networks: data[:social_networks]&.join(", "),
      website_url: data[:website_url],
      address: data[:address]
    )
  end
end
