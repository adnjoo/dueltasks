class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(
      to: @user.email,
      from: DEFAULT_FROM_EMAIL,
      subject: "Welcome to DuelTasks!")
  end
end
