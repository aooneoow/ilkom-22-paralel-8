# controllers/notification_controller.rb
require 'sinatra/base'
require './application_controller'
require './controllers/auth_controller'
require './config/database'

class NotificationController < ApplicationController
  before do
    authenticate!  # Pastikan semua rute di NotificationController diautentikasi
  end

  # Ambil semua notifikasi untuk user yang sedang login
  get '/notifications' do
    user_id = current_user['id']
    results = Database.connection.query("SELECT * FROM notifications WHERE user_id = #{user_id} ORDER BY created_at DESC")

    notifications = results.map do |row|
      {
        id: row['id'],
        user_id: row['user_id'],
        type: row['type'],
        message: row['message'],
        created_at: row['created_at']
      }
    end

    json({ status: 'success', notifications: notifications })
  end

  # Tambah notifikasi baru
  post '/notifications' do
    data = JSON.parse(request.body.read)
    type = data['type']
    message = data['message']

    if type && message
      user_id = current_user['id']
      Database.connection.query("INSERT INTO notifications (user_id, type, message, created_at) VALUES (#{user_id}, '#{type}', '#{message}', NOW())")
      status 201
      json({ status: 'success', message: 'Notification created successfully' })
    else
      halt 400, json({ status: 'error', message: 'Missing required parameters' })
    end
  end

  # Hapus notifikasi berdasarkan ID
  delete '/notifications/:id' do
    notification_id = params[:id]
    user_id = current_user['id']

    # Verifikasi bahwa notifikasi milik pengguna yang login
    notification = Database.connection.query("SELECT * FROM notifications WHERE id = #{notification_id} AND user_id = #{user_id}").first

    if notification
      Database.connection.query("DELETE FROM notifications WHERE id = #{notification_id}")
      json({ status: 'success', message: 'Notification deleted successfully' })
    else
      halt 403, json({ status: 'error', message: 'Unauthorized access to notification' })
    end
  end
end
