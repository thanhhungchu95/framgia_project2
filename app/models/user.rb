class User < ApplicationRecord
  enum gender: [:other, :female, :male]

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  scope :name_sort, ->{order name: :asc}
  scope :select_field, ->{select :id, :avatar, :name, :created_at}

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true, length: {maximum: Settings.max_user_name_length}
  validates :phone, length: {maximum: Settings.max_phone_length}

  def is? other_user
    self == other_user
  end

  def follow other_user
    following << other_user unless following? other_user
  end

  def unfollow other_user
    following.delete other_user if following? other_user
  end

  def following? other_user
    following.include? other_user
  end
end
