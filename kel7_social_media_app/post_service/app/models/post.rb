class Post < ActiveRecord::Base
  validates :content, presence: true
  validates :user_id, presence: true

  after_create :notify_creation

  private

  def notify_creation
    NotificationService.create_notification(
      user_id: self.user_id,
      message: "Post baru telah dibuat!",
      type: 'post_created',
      reference_id: self.id
    )
  end
end