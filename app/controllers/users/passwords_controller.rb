# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    alert_body_text = 'If the email address provided exists in our system, an email has been sent with instructions for creating a new password. Please check your email.'

    if User.find_by_email(params[:user][:email]).blank?
      flash[:success] = alert_body_text
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      super
      unless resource.errors.present?
        flash[:success] = alert_body_text
      end
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    super
    flash[:success] = 'Password was successfully changed!'
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
