require "rails_helper"

RSpec.describe Comment, type: :model do
  context "associations" do
    it do
      is_expected.to belong_to :post
      is_expected.to belong_to :user
    end
  end
  context "validates" do
    it do
      is_expected.to validate_numericality_of(:post_id).only_integer
      is_expected.to validate_presence_of :content
    end
  end
end
