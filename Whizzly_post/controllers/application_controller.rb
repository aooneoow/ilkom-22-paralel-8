require 'sinatra/base'
require 'sinatra/json' # Tambahkan ini
require 'json'
require 'jwt'

class ApplicationController < Sinatra::Base
  # Tambahkan helper untuk JSON
  helpers Sinatra::JSON

  configure do
    enable :logging
    set :show_exceptions, false
  end

  before do
    content_type :json
  end

  def current_user
    @current_user ||= begin
      token = request.env['HTTP_AUTHORIZATION']&.split(' ')&.last
      if token
        payload = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256').first
        User.find(payload['user_id'])
      end
    rescue JWT::DecodeError => e
      nil
    end
  end

  def authenticate!
    unless current_user
      halt 401, { 
        status: 'error', 
        message: 'Authentication required' 
      }.to_json
    end
  end

  def json_params
    @json_params ||= JSON.parse(request.body.read, symbolize_names: true)
  rescue JSON::ParserError
    halt 400, { 
      status: 'error', 
      message: 'Invalid JSON payload' 
    }.to_json
  end

  error JWT::DecodeError do
    status 401
    { status: 'error', message: 'Invalid token' }.to_json
  end

  error do |e|
    status 500
    { status: 'error', message: e.message }.to_json
  end
end