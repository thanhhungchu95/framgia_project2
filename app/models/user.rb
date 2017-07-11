class User < ApplicationRecord
  enum gender: [:other, :female, :male]

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :github]

  mount_uploader :avatar, AvatarUploader

  scope :name_sort, ->{order name: :asc}
  scope :select_field, ->{select :id, :avatar, :name, :created_at}
  scope :admin_select_field, ->{select :id, :name, :email, :is_admin, :created_at}

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :authorizations

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

  class << self
    def from_omniauth auth
      auth_provider = auth.provider
      auth_uid = auth.uid
      auth_info = auth.info

      where(provider: auth_provider, uid: auth_uid).first_or_create do |user|
        user.uid = auth_uid
        user.provider = auth_provider
        user.name = auth_info.name
        user.email = auth_info.email
        user.password = Devise.friendly_token[Settings.min_password_length,
          Settings.max_password_length]
      end
    end

    def new_with_session params, session
      super.tap do |user|
        facebook_data = session["devise.facebook_data"]
        github_data = session["devise.github_data"]

        if data = facebook_data || github_data
          user.email = data["email"] if user.email.blank?
        end
      end
    end
  end
end
