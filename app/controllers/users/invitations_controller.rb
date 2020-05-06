class Users::InvitationsController < Devise::InvitationsController
    before_action :user_params_sanitizer    

    def user_params_sanitizer
        devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :phone_number])
    end
end
