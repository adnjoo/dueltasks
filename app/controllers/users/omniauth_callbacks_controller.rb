class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Successfully signed in with Google!" if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: "Error signing in with Google."
    end
  end

  # Failure action to handle cases where OAuth fails
  def failure
    redirect_to new_user_session_path, alert: "Google authentication failed. Please try again."
  end
end
