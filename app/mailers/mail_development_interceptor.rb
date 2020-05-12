class MailDevelopmentInterceptor
    def self.delivering_email(mail)
      if Rails.env.development? || Rails.env.staging?
        mail.to = "staging.xr.reporting@gmail.com"
        mail.cc = nil
        mail.bcc = nil
      end
    end
  end
