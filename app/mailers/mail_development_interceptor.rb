class MailDevelopmentInterceptor
  def self.delivering_email(mail)
    if Rails.env.development? || Rails.env.staging?
      mail.to = "your-test-email@example.com"
      mail.cc = nil
      mail.bcc = nil
    end
  end
end
