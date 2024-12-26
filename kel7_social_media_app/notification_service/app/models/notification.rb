class Notification < ActiveRecord::Base
  validates :user_id, presence: true
  validates :message, presence: true
  validates :type, presence: true
  
  scope :unread, -> { where(read: false) }
  scope :for_user, ->(user_id) { where(user_id: user_id) }
end