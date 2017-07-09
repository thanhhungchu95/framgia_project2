class TagsController < ApplicationController
  before_action :load_tag, :load_post_by_tag, only: :show
  before_action :load_all_tags, only: :index

  private

  def load_tag
    @tag = Tag.find_by id: params[:id]
    render file: "public/404.html", layout: false unless @tag
  end

  def load_all_tags
    @tags = Tag.select_field.name_sort
  end

  def load_post_by_tag
    posts_filter = @tag.posts.created_time_sort
    @posts = posts_filter.paginer(params[:page]).per Settings.post_per_page
  end
end
