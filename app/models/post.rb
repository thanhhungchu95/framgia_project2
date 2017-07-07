class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, inverse_of: :post, dependent: :destroy
  has_many :tags, through: :post_tags

  mount_uploader :picture, PostPictureUploader

  accepts_nested_attributes_for :post_tags

  validates :user, :content, presence: true
  validates :title, presence: true, length: {maximum: Settings.max_title_length}

  scope :created_time_sort, ->{order created_at: :desc}
  scope :select_field, ->{select :id, :title, :content, :user_id, :view_count, :created_at}
  scope :of, ->(user){where user: user}
end
