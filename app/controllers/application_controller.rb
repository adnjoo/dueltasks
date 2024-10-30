class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # Set the Stripe API key before any controller action is called.
  before_action :set_stripe_key

  # Allow related fields to be set during e.g. account update.
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username, :public, :profile_picture ])
  end

  private

  def set_stripe_key
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
  end
end
