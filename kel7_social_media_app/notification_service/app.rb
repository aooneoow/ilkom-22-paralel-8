require 'sinatra'
require 'json'
require 'sqlite3'

ENV['SERVICE_NAME'] = 'notification'
Dir.mkdir('db') unless Dir.exist?('db')
require_relative 'app/config/database'
setup_database

# Routes untuk Notification
post '/notifications' do
  content_type :json
  request_body = JSON.parse(request.body.read)
  
  db = SQLite3::Database.new('db/development.sqlite3')
  db.results_as_hash = true
  
  begin
    db.execute(
      'INSERT INTO notifications (user_id, message, type, reference_id) VALUES (?, ?, ?, ?)',
      [
        request_body['user_id'],
        request_body['message'],
        request_body['type'],
        request_body['reference_id']
      ]
    )
    
    notif_id = db.last_insert_row_id
    notification = db.get_first_row('SELECT * FROM notifications WHERE id = ?', [notif_id])
    
    status 201
    { status: 'success', notification: notification }.to_json
  rescue SQLite3::Exception => e
    status 400
    { status: 'error', message: e.message }.to_json
  ensure
    db.close
  end
end

get '/notifications/:user_id' do
  content_type :json
  db = SQLite3::Database.new('db/development.sqlite3')
  db.results_as_hash = true
  
  notifications = db.execute(
    'SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC',
    [params[:user_id]]
  )
  db.close
  
  notifications.to_json
end

put '/notifications/:id/read' do
  content_type :json
  db = SQLite3::Database.new('db/development.sqlite3')
  
  begin
    db.execute(
      'UPDATE notifications SET read = 1 WHERE id = ?',
      [params[:id]]
    )
    
    if db.changes > 0
      { status: 'success', message: 'Notifikasi ditandai sebagai dibaca' }.to_json
    else
      status 404
      { status: 'error', message: 'Notifikasi tidak ditemukan' }.to_json
    end
  rescue SQLite3::Exception => e
    status 400
    { status: 'error', message: e.message }.to_json
  ensure
    db.close
  end
end