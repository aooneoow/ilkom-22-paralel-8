require 'concurrent'

class PostService
  def initialize(max_threads: 4)
    @thread_pool = Concurrent::FixedThreadPool.new(max_threads)
    @mutex = Mutex.new
  end

  def create_post(user_id:, content:)
    future = Concurrent::Future.execute(executor: @thread_pool) do
      @mutex.synchronize do
        post = Post.create!(
          user_id: user_id,
          content: content
        )
        
        # Notifikasi ke notification service
        notify_creation(post)
        post
      end
    end
    
    future.value # Menunggu hasil
  end

  private

  def notify_creation(post)
    NotificationService.create(
      user_id: post.user_id,
      message: "Post baru telah dibuat!",
      post_id: post.id
    )
  rescue => e
    puts "Error saat membuat notifikasi: #{e.message}"
  end
end