json.extract! inquiry, :id, :name, :phone_number, :email_address, :message, :created_at, :updated_at
json.url inquiry_url(inquiry, format: :json)
