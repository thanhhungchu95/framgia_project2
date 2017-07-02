class UsersController < ApplicationController
  load_resource only: [:index, :show]
  authorize_resource only: :index
  before_action :load_list_user, only: :index

  private

  def load_list_user
    @users.select(:id, :name, :avatar).order(:name).paginer(params[:page])
      .per Settings.user_per_page
  end
end
