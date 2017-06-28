class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :user, :content, presence: true
  validates :title, presence: true, length: {maximum: Settings.max_title_length}
end
