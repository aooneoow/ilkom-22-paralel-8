require 'sinatra'
require 'json'
require 'sqlite3'
require 'http'

# Service Configuration
ENV['SERVICE_NAME'] = 'comment'

# Ensure db directory exists
Dir.mkdir('db') unless Dir.exist?('db')

# Database Setup
require_relative 'app/config/database'
setup_database

# Helper Methods
def notify_post_owner(owner_id, post_id)
  notification_data = {
    user_id: owner_id,
    message: "Ada komentar baru di post #{post_id}",
    type: 'comment'
  }
  
  HTTP.post(
    "http://localhost:4570/notifications",
    json: notification_data
  )
rescue => e
  puts "Error sending notification: #{e.message}"
end

# Routes
get '/comments/:post_id' do
  content_type :json
  db = SQLite3::Database.new('db/development.sqlite3')
  db.results_as_hash = true
  
  begin
    comments = db.execute(
      'SELECT * FROM comments WHERE post_id = ? ORDER BY created_at DESC',
      [params[:post_id]]
    )
    
    comments.to_json
  ensure
    db.close
  end
end

post '/comments' do
  content_type :json
  request_body = JSON.parse(request.body.read)
  
  # Verify post exists
  post_response = HTTP.get("http://localhost:4567/posts/#{request_body['post_id']}")
  post_data = JSON.parse(post_response.body)
  
  # Ubah pengecekan response
  if !post_response.status.success?
    status 404
    return { status: 'error', message: 'Post tidak ditemukan' }.to_json
  end
  
  # Ambil user_id langsung dari post_data
  post_owner_id = post_data['user_id'] # Sesuaikan dengan struktur response yang benar
  
  db = SQLite3::Database.new('db/development.sqlite3')
  db.results_as_hash = true
  
  begin
    db.execute(
      'INSERT INTO comments (post_id, user_id, content) VALUES (?, ?, ?)',
      [request_body['post_id'], request_body['user_id'], request_body['content']]
    )
    
    # Notify post owner dengan user_id yang benar
    notify_post_owner(post_owner_id, request_body['post_id'])
    
    status 201
    { status: 'success', message: 'Komentar berhasil dibuat' }.to_json
  rescue SQLite3::Exception => e
    status 400
    { status: 'error', message: e.message }.to_json
  ensure
    db.close
  end
end