module ApplicationHelper
  def build_relation
    current_user.active_relationships.build
  end

  def load_relation_with followed
    current_user.active_relationships.find_by followed: followed
  end
end
