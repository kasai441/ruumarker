# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://ruumarker.herokuapp.com'
    resource '*',
             headers: :any,
             methods: %i[get]
  end
end
