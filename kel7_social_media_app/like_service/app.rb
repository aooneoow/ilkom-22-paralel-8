# app.rb for Like Service
require 'sinatra'
require 'json'
require 'sqlite3'
require 'http'

# Service Configuration
configure do
  # Set service name
  ENV['SERVICE_NAME'] = 'like'

  # Create db directory if it doesn't exist
  Dir.mkdir('db') unless Dir.exist?('db')

  # Setup database
  require_relative 'app/config/database'
  setup_database
end

# Database Helper
def get_db
  db = SQLite3::Database.new('db/development.sqlite3')
  db.results_as_hash = true
  db
end

# Error Handlers
error SQLite3::Exception do |e|
  status 400
  { status: 'error', message: e.message }.to_json
end

error StandardError do |e|
  status 500
  { status: 'error', message: e.message }.to_json
end

# Routes
before do
  content_type :json
end

# Get like count for a specific post
get '/likes/:post_id' do |post_id|
  db = get_db

  begin
    like_count = db.get_first_value('SELECT COUNT(*) FROM likes WHERE post_id = ?', [post_id])

    { status: 'success', like_count: like_count }.to_json
  ensure
    db.close if db
  end
end

# Add a like
post '/likes' do
  request_body = JSON.parse(request.body.read)
  db = get_db

  begin
    # Validate post_id by checking Post Service
    post_response = HTTP.get("http://localhost:4567/posts/#{request_body['post_id']}")
    post_data = JSON.parse(post_response.body) rescue nil

    if post_data.nil? || post_data['status'] != 'success' || post_data['data'].nil?
      status 400
      return { status: 'error', message: 'Post tidak valid atau tidak ditemukan' }.to_json
    end

    # Check if like already exists
    existing_like = db.get_first_value(
      'SELECT COUNT(*) FROM likes WHERE post_id = ? AND user_id = ?',
      [request_body['post_id'], request_body['user_id']]
    )

    if existing_like > 0
      status 400
      return { status: 'error', message: 'Like sudah ada' }.to_json
    end

    # Insert new like
    db.execute(
      'INSERT INTO likes (post_id, user_id) VALUES (?, ?)',
      [request_body['post_id'], request_body['user_id']]
    )

    status 201
    { status: 'success', message: 'Like berhasil ditambahkan' }.to_json
  ensure
    db.close if db
  end
end

# Remove a like
delete '/likes' do
  request_body = JSON.parse(request.body.read)
  db = get_db

  begin
    # Validate post_id by checking Post Service
    post_response = HTTP.get("http://localhost:4567/posts/#{request_body['post_id']}")
    post_data = JSON.parse(post_response.body) rescue nil

    if post_data.nil? || post_data['status'] != 'success' || post_data['data'].nil?
      status 400
      return { status: 'error', message: 'Post tidak valid atau tidak ditemukan' }.to_json
    end

    # Check if like exists
    existing_like = db.get_first_value(
      'SELECT COUNT(*) FROM likes WHERE post_id = ? AND user_id = ?',
      [request_body['post_id'], request_body['user_id']]
    )

    if existing_like == 0
      status 404
      return { status: 'error', message: 'Like tidak ditemukan' }.to_json
    end

    # Delete like
    db.execute(
      'DELETE FROM likes WHERE post_id = ? AND user_id = ?',
      [request_body['post_id'], request_body['user_id']]
    )

    { status: 'success', message: 'Like berhasil dihapus' }.to_json
  ensure
    db.close if db
  end
end
