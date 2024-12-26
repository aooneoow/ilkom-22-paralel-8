class LikesController < Sinatra::Base
  post '/likes' do
    like = Like.new(
      user_id: params[:user_id],
      post_id: params[:post_id]
    )
    
    if like.save
      # Notifikasi ke pemilik post
      notify_post_owner(like)
      status 201
      { status: 'success', like: like }.to_json
    else
      status 400
      { status: 'error', errors: like.errors }.to_json
    end
  end
  
  private
  
  def notify_post_owner(like)
    # Dapatkan post owner dari post service
    uri = URI("http://localhost:4567/posts/#{like.post_id}")
    response = Net::HTTP.get(uri)
    post_data = JSON.parse(response)
    
    if post_data['user_id']
      NotificationClient.notify(
        post_data['user_id'],
        "New like on your post",
        like.id
      )
    end
  rescue StandardError => e
    puts "Error notifying post owner: #{e.message}"
  end
end