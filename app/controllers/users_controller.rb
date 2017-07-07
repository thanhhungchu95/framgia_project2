class UsersController < ApplicationController
  load_resource only: :show
  authorize_resource only: [:index, :show]
  before_action :load_list_user, only: :index

  private

  def load_list_user
    @users ||= users_list
  end

  def users_list
    User.select_field.name_sort.paginer(params[:page])
      .per Settings.user_per_page
  end
end
