# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # Override the `update_resource` method to handle profile picture removal and password validation
  def update_resource(resource, params)
    if params[:remove_profile_picture] == "1"
      resource.profile_picture.purge
    end

    # Skip password validation if password fields are blank
    if params[:password].blank? && params[:password_confirmation].blank?
      resource.update_without_password(params.except(:current_password))
    else
      super
    end
  end
end
