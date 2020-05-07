class MailDevelopmentInterceptor
    def self.delivering_email(mail)
      if Rails.env.development?
        mail.to = "staging.xr.reporting@gmail.com"
        mail.cc = nil
        mail.bcc = nil
      end
    end
  end