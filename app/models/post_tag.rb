class PostTag < ApplicationRecord
  belongs_to :post
  belongs_to :tag

  validates :post, presence: true, uniqueness: {scope: :tag}
  validates :tag, presence: true

  accepts_nested_attributes_for :tag
end
