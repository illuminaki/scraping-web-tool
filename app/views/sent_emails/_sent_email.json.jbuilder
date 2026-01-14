json.extract! sent_email, :id, :email, :subject, :body, :status, :message_id, :register_id, :created_at, :updated_at
json.url sent_email_url(sent_email, format: :json)
