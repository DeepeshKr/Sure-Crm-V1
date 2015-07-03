# config/initializers/timeout.rb
Rack::Timeout.timeout = 300  # seconds
Rack::Timeout.wait_timeout = 0