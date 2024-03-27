Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:5173' #'https://taa-logistics-client.vercel.app'
    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head],
             expose: ['X-CSRF-Token'],
             credentials: true
  end
end

