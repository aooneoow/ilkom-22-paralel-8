# app.rb
require 'sinatra'
require './application_controller'
require './controllers/auth_controller'
require './controllers/notification_controller'

# Jalankan AuthController untuk rute autentikasi
class AuthService < AuthController
end

# Jalankan NotificationController untuk rute notifikasi
class NotificationService < NotificationController
end

AuthService.run!
NotificationService.run!
