# controllers/auth_controller.rb
require 'sinatra/base'
require 'bcrypt'
require './application_controller'
require './config/database'

class AuthController < ApplicationController
  # Endpoint untuk login
  post '/auth/login' do
    data = JSON.parse(request.body.read)
    email = data['email']
    password = data['password']

    user = Database.connection.query("SELECT * FROM users WHERE email = '#{email}' LIMIT 1").first

    if user && BCrypt::Password.new(user['password_digest']) == password
      session[:user_id] = user['id']  # Simpan user ID di session
      json({ status: 'success', message: 'Login successful' })
    else
      halt 401, json({ status: 'error', message: 'Invalid email or password' })
    end
  end

  # Endpoint untuk logout
  post '/auth/logout' do
    session.clear  # Hapus data session
    json({ status: 'success', message: 'Logout successful' })
  end

  # Middleware untuk memeriksa autentikasi
  def authenticate!
    unless current_user
      halt 401, json({ 
        status: 'error', 
        message: 'Authentication required' 
      })
    end
  end

  # Helper untuk mendapatkan data pengguna yang sedang login
  def current_user
    if session[:user_id]
      @current_user ||= Database.connection.query("SELECT * FROM users WHERE id = #{session[:user_id]} LIMIT 1").first
    end
  end
end
