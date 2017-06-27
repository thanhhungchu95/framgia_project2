class Relationship < ApplicationRecord
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name

  validates :follower, presence: true, uniqueness: {scope: :followed}
  validates :followed, presence: true
  validate :validate_user_follow_self

  private

  def validate_user_follow_self
    errors.add :followed, I18n.t(".follow_different") if followed.is? follower
  end
end
