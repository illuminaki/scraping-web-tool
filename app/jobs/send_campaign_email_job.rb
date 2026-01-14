# frozen_string_literal: true

# Job to send campaign emails in the background
class SendCampaignEmailJob < ApplicationJob
  queue_as :mailers

  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform(email:, subject:, body:, register_id: nil)
    register = register_id.present? ? Register.find_by(id: register_id) : nil

    service = EmailCampaignService.new(
      email: email,
      subject: subject,
      body: body,
      register: register
    )

    result = service.call

    unless result.success?
      Rails.logger.error("Email sending failed: #{result.message}")
      raise StandardError, result.message # Trigger retry
    end
  end
end
