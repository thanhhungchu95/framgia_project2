class UsersController < ApplicationController
  load_resource only: [:show, :destroy]
  authorize_resource only: [:index, :show]
  before_action :load_list_user, only: :index
  before_action :verify_follow, only: :show

  def destroy
    if user_signed_in? && current_user.is_admin? && @user.destroy
      flash[:notice] = t ".deleted"
    else
      flash.now[:danger] = t ".not_deleted"
    end
    redirect_back fallback_location: root_path
  end

  private

  def load_list_user
    @users ||= users_list
  end

  def users_list
    User.select_field.name_sort.paginer(params[:page])
      .per Settings.user_per_page
  end

  def verify_follow
    return if current_user.is_admin? || current_user.following?(@user)
    flash[:warning] = t ".not_access_user_profile"
    redirect_to root_path
  end
end
