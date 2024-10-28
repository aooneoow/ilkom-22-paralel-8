class Post
  attr_accessor :id, :user_id, :content, :media_urls, :created_at, :updated_at

  def self.all(page: 1, per_page: 10)
    Database.query("SELECT * FROM posts ORDER BY created_at DESC LIMIT ? OFFSET ?", [per_page, (page - 1) * per_page])
  end

  def self.find(id)
    Database.query("SELECT * FROM posts WHERE id = ? LIMIT 1", [id]).first
  end

  def self.create(attributes)
    Database.query("INSERT INTO posts (user_id, content, media_urls, created_at, updated_at) VALUES (?, ?, ?, NOW(), NOW())", [
      attributes[:user_id],
      attributes[:content],
      attributes[:media_urls]
    ])
    
    id = Database.last_insert_id
    find(id)
  end

  def self.update(id, attributes)
    Database.query("UPDATE posts SET content = ?, media_urls = ?, updated_at = NOW() WHERE id = ? AND user_id = ?", [
      attributes[:content],
      attributes[:media_urls],
      id,
      attributes[:user_id]
    ])
    
    find(id)
  end

  def self.delete(id, user_id)
    Database.query("DELETE FROM posts WHERE id = ? AND user_id = ?", [id, user_id])
  end
end