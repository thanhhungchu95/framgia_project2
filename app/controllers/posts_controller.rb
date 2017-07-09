class PostsController < ApplicationController
  load_resource except: [:index, :new, :create]
  authorize_resource only: [:new, :show]
  before_action :increase_view_count, only: :show
  before_action :build_post, only: :new

  def index
    if user = User.find_by(id: params[:user_id])
      post_filter = Post.of(user).select_field.created_time_sort
      @posts = post_filter.paginer(params[:page]).per Settings.post_per_page
      @user = user
    else
      flash[:warning] = t "page_not_found"
      redirect_to root_url
    end
  end

  def create
    @post = current_user.posts.build post_params

    if @post.save
      do_after_create_post_done
    else
      do_after_create_post_failed
    end
  end

  def update
    action = params[:commit]

    if action == t(".cancel")
      do_if_cancel_update_post
    elsif action == t(".save") && @post.update_attributes(post_params)
      do_after_update_post_done
    else
      do_after_update_post_failed
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = t ".deleted"
      redirect_to root_path
    else
      flash.now[:danger] = t ".not_deleted"
      redirect_back fallback_location: root_path
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

  def redirect_to_post
    redirect_to @post
  end

  def do_if_cancel_update_post
    flash[:info] = t ".cancel_update"
    redirect_to_post
  end

  def do_after_update_post_done
    flash[:notice] = t ".update_success"
    redirect_to_post
  end

  def do_after_update_post_failed
    flash[:danger] = t ".update_failed"
    render :edit
  end
end
