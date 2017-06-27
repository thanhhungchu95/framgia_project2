class PostTag < ApplicationRecord
  belongs_to :post
  belongs_to :tag

  validates :post, presence: true, uniqueness: {scope: :tag}
  validates :tag, presence: true
end
