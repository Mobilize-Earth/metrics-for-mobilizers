class UserMailer < ApplicationMailer
  include Devise::Mailers::Helpers

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Reporting Tool')
  end

  def reset_password_instructions(recipient, argument, other_argument)
    devise_mail(recipient, :reset_password_instructions)
  end
end
