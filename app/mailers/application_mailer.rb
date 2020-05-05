class ApplicationMailer < ActionMailer::Base
  default from: 'reporting@organise.earth'
  layout 'mailer'
  before_action :add_inline_attachment!

  def add_inline_attachment!
    attachments.inline['footer_mail.png'] = File.read("#{Rails.root}/public/images/footer_mail.png")
  end
end
