module ApplicationHelper
  def build_relation
    current_user.active_relationships.build
  end

  def load_relation_with followed
    current_user.active_relationships.find_by followed: followed
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
