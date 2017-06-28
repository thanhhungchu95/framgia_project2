class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :post, :user, presence: true
  validates :content, presence: true
end
