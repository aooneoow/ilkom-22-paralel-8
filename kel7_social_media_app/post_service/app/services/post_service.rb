require_relative '../models/post'

class PostService
  def self.create_post(content, user_id)
    post = Post.new(content: content, user_id: user_id)

    if post.save
      # Tambahkan logika tambahan di sini, jika diperlukan
      # Misalnya, kirim notifikasi menggunakan NotificationService
      return post
    else
      raise 'Failed to create post'
    end
  end
end
