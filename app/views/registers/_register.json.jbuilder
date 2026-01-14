json.extract! register, :id, :url, :title, :description, :emails, :phones, :social_networks, :website_url, :address, :list_id, :created_at, :updated_at
json.url register_url(register, format: :json)
