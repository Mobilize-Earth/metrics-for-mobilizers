class UserMailer < ApplicationMailer
  include Devise::Mailers::Helpers
  before_action :add_inline_attachment!

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Reporting Tool')
  end

  def reset_password_instructions(recipient, argument, other_argument)
    devise_mail(recipient, :reset_password_instructions)
  end

  def add_inline_attachment!
    attachments.inline['footer_mail.png'] = File.read("#{Rails.root}/public/images/footer_mail.png")
  end
end
