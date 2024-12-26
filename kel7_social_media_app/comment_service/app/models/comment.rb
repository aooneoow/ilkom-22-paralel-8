class Comment < ActiveRecord::Base
  validates :content, presence: true
  validates :user_id, presence: true
  validates :post_id, presence: true

  after_create :notify_creation

  private

  def notify_creation
    NotificationService.create_notification(
      user_id: self.user_id,
      message: "Komentar baru pada post #{self.post_id}",
      type: 'comment_created',
      reference_id: self.id
    )
  end
end