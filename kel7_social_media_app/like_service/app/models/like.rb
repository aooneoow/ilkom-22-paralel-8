require 'active_record'

class Like < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :post_id, presence: true
  validates :user_id, presence: true
end
