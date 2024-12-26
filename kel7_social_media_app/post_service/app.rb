require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require 'sqlite3'
require 'http'
require 'concurrent'

# Thread pool dengan 5 thread
THREAD_POOL = Concurrent::FixedThreadPool.new(5)

# Service Configuration
configure do
  enable :cross_origin
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

options "*" do
  response.headers["Allow"] = "GET, POST, PUT, DELETE, OPTIONS"
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization, X-Requested-With"
  200
end

  # Set service name
  ENV['SERVICE_NAME'] = 'post'

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

# Get complete post data including comments and likes
get '/posts/:id/complete' do |id|
  db = get_db

  begin
    # Fetch post data
    post = db.get_first_row('SELECT * FROM posts WHERE id = ?', [id])
    halt 404, { status: 'error', message: 'Post tidak ditemukan' }.to_json if post.nil?

    # Fetch comments from Comment Service
    comments_response = HTTP.get("http://localhost:4568/comments/#{id}")
    if comments_response.status.success?
      comments_data = JSON.parse(comments_response.body) rescue []
      comments = comments_data.is_a?(Array) ? comments_data : comments_data['comments'] || []
    else
      comments = []
    end

    # Fetch like count from Like Service
    likes_response = HTTP.get("http://localhost:4569/likes/#{id}")
    like_count = if likes_response.status.success?
                   JSON.parse(likes_response.body)['like_count'] rescue 0
                 else
                   0
                 end

    # Combine all data
    complete_post = {
      post: post,
      comments: comments,
      like_count: like_count
    }

    { status: 'success', data: complete_post }.to_json
  ensure
    db.close if db
  end
end

# Create new post
post '/posts' do
  request_body = JSON.parse(request.body.read)
  db = get_db

  begin
    db.execute(
      'INSERT INTO posts (content, user_id) VALUES (?, ?)',
      [request_body['content'], request_body['user_id']]
    )

    status 201
    { status: 'success', message: 'Post berhasil dibuat' }.to_json
  ensure
    db.close if db
  end
end

# Get all posts
get '/posts' do
  db = get_db

  begin
    posts = db.execute('SELECT * FROM posts ORDER BY created_at DESC')
    { status: 'success', data: posts }.to_json
  ensure
    db.close if db
  end
end

# Get single post
get '/posts/:id' do |id|
  db = get_db

  begin
    post = db.get_first_row('SELECT * FROM posts WHERE id = ?', [id])
    halt 404, { status: 'error', message: 'Post tidak ditemukan' }.to_json if post.nil?

    { status: 'success', data: post }.to_json
  ensure
    db.close if db
  end
end

# Update post
put '/posts/:id' do |id|
  request_body = JSON.parse(request.body.read)
  db = get_db

  begin
    result = db.execute(
      'UPDATE posts SET content = ? WHERE id = ?',
      [request_body['content'], id]
    )

    halt 404, { status: 'error', message: 'Post tidak ditemukan' }.to_json if result.changes.zero?

    { status: 'success', message: 'Post berhasil diupdate' }.to_json
  ensure
    db.close if db
  end
end

# Delete post
delete '/posts/:id' do |id|
  db = get_db

  begin
    result = db.execute('DELETE FROM posts WHERE id = ?', [id])
    halt 404, { status: 'error', message: 'Post tidak ditemukan' }.to_json if result.changes.zero?

    { status: 'success', message: 'Post berhasil dihapus' }.to_json
  ensure
    db.close if db
  end
end
