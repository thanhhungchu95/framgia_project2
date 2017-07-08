class RelationshipsController < ApplicationController
  before_action :load_follow_resource, only: :create
  before_action :load_unfollow_resource, only: :destroy

  def create
    if current_user.follow @user
      relate = Relationship.find_by followed: @user, follower: current_user
      redirect_on_failed unless relate
      render json: {status: :success, user: @user.id, text: t(".following"), relate: relate.id}
    else
      render json: {status: :error, message: t(".follow_error")}
    end
  end

  def destroy
    if current_user.unfollow @user
      render json: {status: :success, user: @user.id, text: t(".follow")}
    else
      render json: {status: :error, message: t(".unfollow_error")}
    end
  end

  private

  def load_follow_resource
    @user = User.find_by id: params[:followed_id]
    redirect_on_failed unless @user
  end

  def load_unfollow_resource
    @user = Relationship.find_by(id: params[:relationship_id]).followed
    redirect_on_failed unless @user
  end

  def redirect_on_failed
    render file: "public/404.html", layout: false
  end
end
