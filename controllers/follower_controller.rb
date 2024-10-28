# controllers/follower_controller.rb
require 'sinatra'
require 'sequel'
require 'mysql2'

# Koneksi ke database MySQL
DB = Sequel.connect(
  adapter: :mysql2,
  host: 'localhost',
  database: 'follower_service',
  user: 'user',
  password: 'password'
)

# Model untuk menyimpan followers
DB.create_table? :followers do
  primary_key :id
  Integer :user_id, null: false
  Integer :follower_id, null: false
  DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
  unique [:user_id, :follower_id]
end

followers_table = DB[:followers]

# Endpoint untuk mengikuti pengguna
post '/follow/:user_id' do
  follower_id = params[:follower_id].to_i
  user_id = params[:user_id].to_i

  begin
    followers_table.insert(user_id: user_id, follower_id: follower_id)
    status 200
    body 'Followed successfully'
  rescue Sequel::UniqueConstraintViolation
    status 400
    body 'Already following this user'
  end
end

# Endpoint untuk berhenti mengikuti pengguna
post '/unfollow/:user_id' do
  follower_id = params[:follower_id].to_i
  user_id = params[:user_id].to_i

  followers_table.where(user_id: user_id, follower_id: follower_id).delete
  status 200
  body 'Unfollowed successfully'
end

# Endpoint untuk mendapatkan daftar followers
get '/followers/:user_id' do
  user_id = params[:user_id].to_i
  followers = followers_table.where(user_id: user_id).select_map(:follower_id)
  status 200
  body followers.to_json
end

# Endpoint untuk mendapatkan daftar following
get '/following/:user_id' do
  user_id = params[:user_id].to_i
  following = followers_table.where(follower_id: user_id).select_map(:user_id)
  status 200
  body following.to_json
end
