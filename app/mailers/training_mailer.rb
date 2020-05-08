class TrainingMailer < ApplicationMailer
  before_action :add_inline_attachment!

  def success_mailer(user)
    @user = user
    mail(to: @user.email, subject: 'Created new training')
  end

end
