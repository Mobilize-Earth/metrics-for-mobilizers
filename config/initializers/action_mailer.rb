ActiveSupport.on_load(:active_record) do
  ActionMailer::Base.register_interceptor(MailDevelopmentInterceptor)
end