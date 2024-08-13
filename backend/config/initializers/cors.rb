Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3001' # Adjust the port for the React app
    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :delete, :options]
  end
end