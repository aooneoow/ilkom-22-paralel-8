# application_controller.rb
require 'sinatra/base'
require 'json'
require './config/database'

class ApplicationController < Sinatra::Base
  before do
    content_type :json
    response.headers['Access-Control-Allow-Origin'] = settings.allow_origin || '*'
    response.headers['Access-Control-Allow-Methods'] = settings.allow_methods.join(', ') || 'GET, POST, DELETE, OPTIONS'
  end

  def authenticate!
    unless current_user
      halt 401, json({ 
        status: 'error', 
        message: 'Authentication required' 
      })
    end
  end

  def current_user
    if session[:user_id]
      @current_user ||= Database.koneksi.query(
        "SELECT * FROM users WHERE id = ? AND status = 'active' LIMIT 1", 
        session[:user_id]
      ).first
    end
  end

  get '/' do
    json({
      status: 'success',
      message: 'Welcome to the Notification Service API',
      version: '1.0',
      endpoints: {
        notifications: {
          list: {
            method: 'GET',
            url: '/notifications/:user_id',
            description: 'Get all notifications for a specific user'
          },
          create: {
            method: 'POST',
            url: '/notifications',
            description: 'Create a new notification'
          },
          delete: {
            method: 'DELETE',
            url: '/notifications/:id',
            description: 'Delete a notification by ID'
          }
        }
      }
    })
  end

  not_found do
    json({
      status: 'error',
      message: 'Route not found'
    })
  end

  error do
    json({
      status: 'error',
      message: 'An internal server error occurred'
    })
  end
end
