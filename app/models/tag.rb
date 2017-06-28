class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  before_save :downcase_tag_name

  validates :name, presence: true, length: {maximum: Settings.max_tag_length},
    uniqueness: {case_sensitive: false}

  private

  def downcase_tag_name
    name.downcase!
  end
end
