class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |_|
    flash[:warning] = t ".not_access"
    redirect_to root_url
  end
end
