# frozen_string_literal: true

# Job to scrape all registers in a list
class ScrapeListJob < ApplicationJob
  queue_as :default

  def perform(list_id)
    list = List.find_by(id: list_id)
    return unless list

    list.registers.find_each do |register|
      # Enqueue individual scraping jobs to parallelize
      ScrapeWebsiteJob.perform_later(register.id)
    end
  end
end
