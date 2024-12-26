require 'sinatra/base'
require 'json'
require 'net/http'

class PostsController < Sinatra::Base
  # Rute untuk menandai postingan sebagai complete dan mengambil data terkait
  get '/posts/:id/complete' do
    content_type :json

    post_id = params['id']

    # Contoh data postingan (Anda dapat menggantinya dengan data nyata dari database)
    post = {
      id: post_id,
      title: "Example Post",
      content: "This is a sample post."
    }

    # Ambil data komentar dan likes menggunakan metode helper
    comments = get_comments(post_id)
    likes = get_likes(post_id)

    # Kembalikan data dalam format JSON
    {
      post: post,
      comments: comments,
      likes: likes
    }.to_json
  end

  private

  # Metode untuk mengambil komentar berdasarkan post_id
  def get_comments(post_id)
    uri = URI("http://localhost:4568/comments/#{post_id}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  rescue StandardError => e
    puts "Error fetching comments: #{e.message}"
    []
  end

  # Metode untuk mengambil likes berdasarkan post_id
  def get_likes(post_id)
    uri = URI("http://localhost:4569/likes/#{post_id}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  rescue StandardError => e
    puts "Error fetching likes: #{e.message}"
    []
  end
end
