class AdminsController < ApplicationController
  layout "admin"
  before_action :admin_require, only: [:user_manager, :post_manager]
  before_action :admin_load_users, only: :user_manager
  before_action :admin_load_posts, only: :post_manager

  private

  def admin_require
    return if user_signed_in? && current_user.is_admin?
    flash[:warning] = t ".cannot_access_admin_page"
    redirect_to root_path
  end

  def admin_load_users
    @users = User.admin_select_field.paginer(params[:page]).per Settings.user_per_page
  end

  def admin_load_posts
    @posts = Post.select_field.paginer(params[:page]).per Settings.post_per_page
  end
end
