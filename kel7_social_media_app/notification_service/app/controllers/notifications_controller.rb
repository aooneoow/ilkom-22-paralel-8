class NotificationsController < Sinatra::Base
  before do
    content_type :json
  end

  # Membuat notifikasi baru
  post '/notifications' do
    notification = Notification.new(
      user_id: params[:user_id],
      message: params[:message],
      type: params[:type],
      reference_id: params[:reference_id]
    )

    if notification.save
      status 201
      { status: 'success', notification: notification }.to_json
    else
      status 400
      { status: 'error', errors: notification.errors }.to_json
    end
  end

  # Mendapatkan notifikasi untuk user tertentu
  get '/notifications/:user_id' do
    notifications = Notification.for_user(params[:user_id])
                              .order(created_at: :desc)
    { status: 'success', notifications: notifications }.to_json
  end

  # Menandai notifikasi sebagai sudah dibaca
  put '/notifications/:id/read' do
    notification = Notification.find(params[:id])
    notification.update(read: true)
    { status: 'success', notification: notification }.to_json
  end
end