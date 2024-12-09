class Notification < ActiveRecord::Base
  # Validasi
  validates :message, presence: true
  validates :user_id, presence: true

  # Scope untuk mendapatkan notifikasi terbaru
  scope :unread, -> { where(read: false) }
end
