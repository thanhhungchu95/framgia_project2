class CommentsController < ApplicationController
  before_action :build_comment, only: :create
  before_action :load_comment, only: [:update, :destroy]

  def create
    if @comment.save
      render json: {status: :success, html: render_to_string(@comment)}
    else
      render json: {status: :error, message: t(".comment_error")}
    end
  end

  def update
    if @comment.update_attributes content: params[:content]
      render json: {status: :success, html: render_to_string(@comment)}
    else
      render json: {status: :error, message: t(".update_comment_error")}
    end
  end

  def destroy
    if @comment.destroy
      render json: {status: :success, html: :success}
    else
      render json: {status: :error, message: t(".delete_comment_error")}
    end
  end

  private

  def build_comment
    post = Post.find_by id: params[:post_id]
    redirect_on_failed unless post
    @comment = post.comments.build content: params[:comment][:content],
      user: current_user
  end

  def load_comment
    @comment = Comment.find_by id: params[:id]
    redirect_on_failed unless @comment
  end

  def redirect_on_failed
    render file: "public/404.html", layout: false
  end
end
