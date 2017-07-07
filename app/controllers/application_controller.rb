class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied, ActiveRecord::RecordNotFound do |exception|
    flash[:warning] = exception.message
    redirect_to root_url
  end
end
