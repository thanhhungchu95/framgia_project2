class PostsController < ApplicationController
  load_resource only: :show
  authorize_resource only: [:new, :show]
  before_action :increase_view_count, only: :show
  before_action :build_post, only: :new

  def create
    @post = current_user.posts.build post_params

    if @post.save
      do_after_create_post_done
    else
      do_after_create_post_failed
    end
  end

  private

  def post_params
    params.require(:post).permit :title, :content, :picture,
      post_tags_attributes: [[tag_attributes: [:name]]]
  end

  def increase_view_count
    @post.update_attributes view_count: (@post.view_count + 1)
  end

  def do_after_create_post_done
    flash[:notice] = t ".created"
    redirect_to @post
  end

  def do_after_create_post_failed
    flash.now[:error] = t ".not_created"
    render :new
  end

  def build_post
    return unless user_signed_in?
    @post = current_user.posts.build
    @post.post_tags.build.build_tag
  end
end
