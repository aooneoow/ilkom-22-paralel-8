class PostService
  def self.get_all_posts(page: 1, per_page: 10)
    posts = Post.all(page: page, per_page: per_page)
    posts.map do |post|
      {
        id: post.id,
        user_id: post.user_id,
        content: post.content,
        media_urls: post.media_urls,
        created_at: post.created_at,
        updated_at: post.updated_at
      }
    end
  end

  def self.get_post(id)
    post = Post.find(id)
    return nil unless post
    
    {
      id: post.id,
      user_id: post.user_id,
      content: post.content,
      media_urls: post.media_urls,
      created_at: post.created_at,
      updated_at: post.updated_at
    }
  end

  def self.create_post(attributes)
    post = Post.create(attributes)
    return nil unless post
    
    {
      id: post.id,
      user_id: post.user_id,
      content: post.content,
      media_urls: post.media_urls,
      created_at: post.created_at,
      updated_at: post.updated_at
    }
  end

  def self.update_post(attributes)
    post = Post.update(attributes[:id], attributes)
    return nil unless post
    
    {
      id: post.id,
      user_id: post.user_id,
      content: post.content,
      media_urls: post.media_urls,
      created_at: post.created_at,
      updated_at: post.updated_at
    }
  end

  def self.delete_post(id, user_id)
    Post.delete(id, user_id)
  end
end