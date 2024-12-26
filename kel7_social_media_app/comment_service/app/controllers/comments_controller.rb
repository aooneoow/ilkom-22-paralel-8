class CommentsController < Sinatra::Base
  post '/comments' do
    comment = Comment.new(
      content: params[:content],
      user_id: params[:user_id],
      post_id: params[:post_id]
    )
    
    if comment.save
      # Notifikasi ke pemilik post
      notify_post_owner(comment)
      status 201
      { status: 'success', comment: comment }.to_json
    else
      status 400
      { status: 'error', errors: comment.errors }.to_json
    end
  end
  
  private
  
  def notify_post_owner(comment)
    # Dapatkan post owner dari post service
    uri = URI("http://localhost:4567/posts/#{comment.post_id}")
    response = Net::HTTP.get(uri)
    post_data = JSON.parse(response)
    
    if post_data['user_id']
      NotificationClient.notify(
        post_data['user_id'],
        "New comment on your post",
        comment.id
      )
    end
  rescue StandardError => e
    puts "Error notifying post owner: #{e.message}"
  end
end