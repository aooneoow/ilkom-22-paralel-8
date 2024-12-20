class CommentService
  def self.create_comment(content, post_id, user_id)
    comment = Comment.new(content: content, post_id: post_id, user_id: user_id)
    
    if comment.save
      # Logika tambahan (opsional)
      # Contoh: Mengirim notifikasi ke user atau post owner
      return comment
    else
      raise 'Failed to create comment'
    end
  end
end
