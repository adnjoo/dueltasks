# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # Override the `update_resource` method to handle profile picture removal
  def update_resource(resource, params)
    if params[:remove_profile_picture] == "1"
      resource.profile_picture.purge
    end

    # Call the original update method with the remaining parameters
    super
  end
end
