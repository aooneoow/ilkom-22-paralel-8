require_relative '../models/like'

class LikeService
  # Menambahkan like pada postingan
  def self.create_like(post_id, user_id)
    raise 'Invalid post_id or user_id' if post_id.nil? || user_id.nil?

    begin
      like = Like.new(post_id: post_id, user_id: user_id)

      if like.save
        puts "[INFO] Like created: Post ID: #{post_id}, User ID: #{user_id}"
        return like
      else
        puts "[ERROR] Failed to create like: #{like.errors.full_messages.join(', ')}"
        raise 'Failed to like the post'
      end
    rescue => e
      puts "[ERROR] Exception in create_like: #{e.message}"
      raise e
    end
  end

  # Menghapus like berdasarkan post_id dan user_id
  def self.delete_like(post_id, user_id)
    raise 'Invalid post_id or user_id' if post_id.nil? || user_id.nil?

    begin
      like = Like.find_by(post_id: post_id, user_id: user_id)

      if like
        like.destroy
        puts "[INFO] Like deleted: Post ID: #{post_id}, User ID: #{user_id}"
      else
        puts "[WARN] Like not found for Post ID: #{post_id}, User ID: #{user_id}"
        raise 'Like not found'
      end
    rescue => e
      puts "[ERROR] Exception in delete_like: #{e.message}"
      raise e
    end
  end
end
