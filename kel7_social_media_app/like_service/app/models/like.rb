class Like < ActiveRecord::Base
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :user_id, uniqueness: { scope: :post_id }

  after_create :notify_creation

  private

  def notify_creation
    NotificationService.create_notification(
      user_id: self.user_id,
      message: "Like baru pada post #{self.post_id}",
      type: 'like_created',
      reference_id: self.id
    )
  end
end