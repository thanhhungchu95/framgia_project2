class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    request_facebook_env = request.env["omniauth.auth"]
    user = User.from_omniauth request_facebook_env

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request_facebook_env
      redirect_to new_user_registration_url
    end
  end

  def github
    request_github_env = request.env["omniauth.auth"]
    user = User.from_omniauth request_github_env

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    else
      session["devise.github_data"] = request_github_env
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
