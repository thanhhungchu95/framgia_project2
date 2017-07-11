class PostsController < ApplicationController
  load_resource except: [:index, :new, :create]
  authorize_resource only: [:new, :show]
  before_action :increase_view_count, only: :show
  before_action :build_post, only: :new

  def index
    keyword = params[:q]

    if keyword && keyword.remove("%").present?
      load_search_post
    elsif @user = User.find_by(id: params[:user_id])
      load_user_post
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
    if @post.update_attributes post_params
      flash[:notice] = t ".update_success"
      redirect_to_post
    else
      flash[:danger] = t ".update_failed"
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = t ".deleted"
      if current_user.is_admin?
        reload_view
      else
        redirect_to root_path
      end
    else
      flash.now[:danger] = t ".not_deleted"
      reload_view
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

  def load_user_post
    @posts = Post.of(@user).select_field.created_time_sort.paginer(params[:page])
             .per Settings.post_per_page
  end

  def load_search_post
    @posts = Post.search(params[:q]).paginer(params[:page]).per Settings.post_per_page
  end

  def reload_view
    redirect_back fallback_location: root_path
  end
end
