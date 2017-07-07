class StaticsController < ApplicationController
  before_action :load_user_list, :load_post_list, only: :home

  private

  def load_user_list
    user_filter = User.select_field.sort_by{|user| user.posts.count}.reverse
    @users = user_filter.take Settings.hot_authors_amount
  end

  def load_post_list
    post_filter = Post.select_field.created_time_sort
    @posts = post_filter.paginer(params[:page]).per Settings.post_per_page
  end
end
