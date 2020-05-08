class TrainingMailer < ApplicationMailer

  def success_mailer(user)
    @user = user
    mail(to: @user.email, subject: 'Created new training')
  end

end
