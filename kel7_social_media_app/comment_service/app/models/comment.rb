class Comment < ActiveRecord::Base
  # Validasi bahwa content, post_id, dan user_id tidak boleh kosong
  validates :content, presence: true
  validates :post_id, presence: true
  validates :user_id, presence: true

  # Scope untuk mengambil komentar terbaru
  scope :latest, -> { order(created_at: :desc) }
end
