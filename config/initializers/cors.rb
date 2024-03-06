Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:5173' # Will need to change this to the actual front end URL
      resource '*', headers: :any, methods: [:get, :post, :patch, :put, :delete, :options, :head]
    end
  end
  