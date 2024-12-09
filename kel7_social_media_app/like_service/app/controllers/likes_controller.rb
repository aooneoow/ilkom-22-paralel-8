require 'sinatra/base'
require 'json'
require_relative '../models/like'
require_relative '../services/like_service'

class LikesController < Sinatra::Base
  # Endpoint untuk memberikan like pada postingan
  post '/likes' do
    post_id = params[:post_id]
    user_id = params[:user_id]

    begin
      like = LikeService.create_like(post_id, user_id)
      status 201
      like.to_json
    rescue StandardError => e
      status 400
      { error: e.message }.to_json
    end
  end

  # Endpoint untuk menghapus like
  delete '/likes' do
    post_id = params[:post_id]
    user_id = params[:user_id]

    begin
      LikeService.delete_like(post_id, user_id)
      status 200
      { message: "Like removed successfully" }.to_json
    rescue StandardError => e
      status 400
      { error: e.message }.to_json
    end
  end

  # Endpoint untuk mendapatkan jumlah like pada sebuah postingan
  get '/likes/:post_id' do
    post_id = params[:post_id]
    like_count = Like.where(post_id: post_id).count
    { like_count: like_count }.to_json
  end
end
