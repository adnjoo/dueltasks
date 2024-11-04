class StaticController < ApplicationController
  def pricing
    @user = current_user
  end
end
