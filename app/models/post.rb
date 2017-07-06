class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, inverse_of: :post, dependent: :destroy
  has_many :tags, through: :post_tags

  mount_uploader :picture, PostPictureUploader

  accepts_nested_attributes_for :post_tags

  validates :user, :content, presence: true
  validates :title, presence: true, length: {maximum: Settings.max_title_length}
end
