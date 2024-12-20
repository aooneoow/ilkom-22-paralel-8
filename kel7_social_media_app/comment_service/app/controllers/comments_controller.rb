require 'sinatra'
require 'json'
require_relative '../models/comment'

class CommentsController < Sinatra::Base
  # Endpoint untuk membuat komentar baru
  post '/comments' do
    content = params[:content]
    post_id = params[:post_id]
    user_id = params[:user_id]

    comment = Comment.new(content: content, post_id: post_id, user_id: user_id)

    if comment.save
      status 201
      comment.to_json
    else
      status 400
      { error: "Invalid data" }.to_json
    end
  end

  # Endpoint untuk mendapatkan semua komentar terbaru
  get '/comments' do
    comments = Comment.latest.limit(10)
    comments.to_json
  end

  # Endpoint untuk menghapus komentar berdasarkan ID
  delete '/comments/:id' do
    comment = Comment.find_by(id: params[:id])

    if comment
      comment.destroy
      status 200
      { message: "Comment deleted successfully" }.to_json
    else
      status 404
      { error: "Comment not found" }.to_json
    end
  end
end
