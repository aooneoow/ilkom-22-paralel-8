require 'sinatra/base'
require 'json'
require_relative '../models/post'
require_relative '../services/post_service'

class PostsController < Sinatra::Base
  # Endpoint untuk membuat postingan baru
  post '/posts' do
    content = params[:content]
    user_id = params[:user_id]

    begin
      post = PostService.create_post(content, user_id)
      status 201
      post.to_json
    rescue StandardError => e
      status 400
      { error: e.message }.to_json
    end
  end

  # Endpoint untuk mendapatkan semua postingan terbaru
  get '/posts' do
    posts = Post.latest.limit(10)
    posts.to_json
  end

  # Endpoint untuk menghapus postingan berdasarkan ID
  delete '/posts/:id' do
    post = Post.find_by(id: params[:id])

    if post
      post.destroy
      status 200
      { message: "Post deleted successfully" }.to_json
    else
      status 404
      { error: "Post not found" }.to_json
    end
  end
end
