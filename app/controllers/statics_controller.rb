class StaticsController < ApplicationController
  before_action :load_hot_authors, only: [:home, :popular, :following]
  before_action :load_new_posts, only: :home
  before_action :load_popular_posts, only: :popular
  before_action :signin_required, :load_following_posts, only: :following

  private

  def load_hot_authors
    user_filter = User.select_field.sort_by{|user| user.posts.count}.reverse
    @users ||= user_filter.take Settings.hot_authors_amount
  end

  def load_new_posts
    post_filter = Post.select_field.created_time_sort
    @new_posts = post_filter.paginer(params[:page]).per Settings.post_per_page
  end

  def load_popular_posts
    post_filter = Post.select_field.view_count_sort
    @popular_posts = post_filter.paginer(params[:page]).per Settings.post_per_page
  end

  def load_following_posts
    post_filter = Post.select_field.of(current_user.following).created_time_sort
    @following_posts = post_filter.paginer(params[:page]).per Settings.post_per_page
  end

  def signin_required
    return if user_signed_in?
    flash[:warning] = t ".signin_first"
    redirect_to root_url
  end
end
