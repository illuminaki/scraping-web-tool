# frozen_string_literal: true

# Service responsible for sending email campaigns
# Integrates with OpenAI for content generation (optional)
class EmailCampaignService
  attr_reader :errors, :sent_email

  def initialize(email:, subject:, body:, register: nil)
    @email = email
    @subject = subject
    @body = body
    @register = register
    @errors = []
    @sent_email = nil
  end

  def call
    return failure("Email is required") if @email.blank?
    return failure("Subject is required") if @subject.blank?
    return failure("Body is required") if @body.blank?

    send_email
  end

  def success?
    @errors.empty?
  end

  def message
    if success?
      "Email sent successfully to #{@email}"
    else
      @errors.join(", ")
    end
  end

  private

  def failure(message)
    @errors << message
    self
  end

  def send_email
    # Generate enhanced content with AI if OpenAiService is available
    enhanced_body = enhance_with_ai(@body)
    image_url = generate_image(@body)

    # Send the email
    mail = deliver_email(enhanced_body, image_url)

    if mail
      create_sent_email_record(mail.message_id)
    else
      failure("Failed to deliver email")
    end

    self
  rescue StandardError => e
    failure("Error sending email: #{e.message}")
    Rails.logger.error("EmailCampaignService error: #{e.message}")
    self
  end

  def enhance_with_ai(body)
    return body unless defined?(OpenAiService)

    OpenAiService.chat(body)
  rescue StandardError => e
    Rails.logger.warn("AI enhancement failed: #{e.message}")
    body
  end

  def generate_image(prompt)
    return nil unless defined?(OpenAiService)

    OpenAiService.generate_image(prompt)
  rescue StandardError => e
    Rails.logger.warn("Image generation failed: #{e.message}")
    nil
  end

  def deliver_email(body, image_url)
    # Use your mailer here
    if defined?(SimpleEmailMailer)
      SimpleEmailMailer.send_email(@email, @subject, body, image_url).deliver_now
    else
      # Fallback to Action Mailer
      CampaignMailer.campaign_email(
        to: @email,
        subject: @subject,
        body: body,
        image_url: image_url
      ).deliver_now
    end
  end

  def create_sent_email_record(message_id)
    @sent_email = SentEmail.create!(
      email: @email,
      subject: @subject,
      body: @body,
      register: @register,
      message_id: message_id,
      status: "sent"
    )
  end
end
