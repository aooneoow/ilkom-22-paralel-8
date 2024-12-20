require 'sinatra'
require 'json'
require_relative '../models/notification'

class NotificationsController < Sinatra::Base
  # Endpoint untuk membuat notifikasi baru
  post '/notifications' do
    user_id = params[:user_id]
    message = params[:message]

    notification = Notification.new(user_id: user_id, message: message)

    if notification.save
      status 201
      notification.to_json
    else
      status 400
      { error: "Invalid data" }.to_json
    end
  end

  # Endpoint untuk mengambil notifikasi pengguna
  get '/notifications/:user_id' do
    user_id = params[:user_id]

    notifications = Notification.where(user_id: user_id).order(created_at: :desc)
    notifications.to_json
  end

  # Endpoint untuk menandai notifikasi sebagai telah dibaca
  put '/notifications/:id/read' do
    notification = Notification.find_by(id: params[:id])

    if notification
      notification.update(read: true)
      status 200
      { message: "Notification marked as read" }.to_json
    else
      status 404
      { error: "Notification not found" }.to_json
    end
  end
end
