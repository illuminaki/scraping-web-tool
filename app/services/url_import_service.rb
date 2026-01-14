# frozen_string_literal: true

# Service responsible for importing URLs from a text file
# Filters out excluded domains and ensures uniqueness
class UrlImportService
  include UrlValidator

  URL_PATTERN = %r{https?://\S+}

  attr_reader :list, :file, :errors, :imported_count, :skipped_count

  def initialize(list:, file:)
    @list = list
    @file = file
    @errors = []
    @imported_count = 0
    @skipped_count = 0
  end

  def call
    return failure("No file provided") unless file_valid?

    urls = extract_urls
    filtered_urls = filter_and_deduplicate(urls)

    import_urls(filtered_urls)

    self
  end

  def success?
    @errors.empty?
  end

  def message
    if success?
      "Imported #{@imported_count} URLs. Skipped #{@skipped_count} (duplicates or excluded)."
    else
      @errors.join(", ")
    end
  end

  private

  def file_valid?
    @file.present? && @file.respond_to?(:read)
  end

  def failure(message)
    @errors << message
    self
  end

  def extract_urls
    content = @file.read
    content.scan(URL_PATTERN)
  end

  def filter_and_deduplicate(urls)
    # Remove excluded domains
    valid_urls = self.class.filter_urls(urls)

    # Get existing URLs in this list
    existing_urls = @list.registers.pluck(:url)

    # Remove already existing URLs
    new_urls = valid_urls - existing_urls

    @skipped_count = urls.length - new_urls.length

    new_urls
  end

  def import_urls(urls)
    urls.each do |url|
      register = @list.registers.build(url: url)
      if register.save
        @imported_count += 1
      else
        @errors << "Failed to import: #{url}"
      end
    end
  end
end
