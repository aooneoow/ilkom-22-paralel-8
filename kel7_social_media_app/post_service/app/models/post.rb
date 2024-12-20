require 'active_record'

class Post < ActiveRecord::Base
  validates :content, presence: true
  validates :user_id, presence: true

  scope :latest, -> { order(created_at: :desc) }
end
