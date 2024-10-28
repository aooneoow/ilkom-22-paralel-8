require 'sinatra/base'
require 'sinatra/json' # Tambahkan ini
require 'json'
require 'dotenv/load'
require './controllers/application_controller'
require './controllers/post_controller'

class WhizzlyApp < Sinatra::Base
  # Tambahkan helper untuk JSON
  helpers Sinatra::JSON

  configure do
    enable :logging
    enable :sessions
    set :session_secret, ENV['JWT_SECRET']
    
    # CORS configuration
    set :allow_origin, '*'
    set :allow_methods, [:get, :post, :put, :delete, :options]
    set :allow_headers, ['*', 'Content-Type', 'Accept', 'Authorization']
  end

  # Root route
  get '/' do
    content_type :json
    { 
      status: 'success',
      message: 'Welcome to Whizzly Post Service API',
      version: '1.0'
    }.to_json 
  end

  # Handle CORS preflight requests
  options "*" do
    response.headers["Allow"] = "GET, POST, PUT, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept"
    response.headers["Access-Control-Allow-Origin"] = "*"
    200
  end

  # Mount controllers
  use PostController

  # Error handling
  not_found do
    content_type :json
    status 404
    { status: 'error', message: 'Route not found' }.to_json
  end

  error do
    content_type :json
    status 500
    { status: 'error', message: 'Internal server error' }.to_json
  end
end