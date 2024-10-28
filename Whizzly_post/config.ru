require './app'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', 
      headers: :any, 
      methods: [:get, :post, :put, :patch, :delete, :options],
      expose: ['Authorization']
  end
end

run WhizzlyApp