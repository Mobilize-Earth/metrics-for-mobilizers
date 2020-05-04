class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :authenticate_user!

    def after_sign_in_path_for(resource)
        if current_user.role == 'admin' then
            admins_index_url
        elsif current_user.role == 'external' then
            external_root_path
        end
    end

    rescue_from CanCan::AccessDenied do |exception|
        if current_user.role == 'admin' then
            redirect_to admins_index_url
        elsif current_user.role == 'external' then
            redirect_to external_root_path
        end
        flash[:error] = exception.message
    end

end
