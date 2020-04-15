class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :authenticate_user!
    skip_before_action :authenticate_user!, :only => [:index]

    def after_sign_in_path_for(resource)
        if @user.role == 'admin' then
            admins_index_url
        elsif @user.role == 'external' then
            dashboard_index_url
        end
    end

    rescue_from CanCan::AccessDenied do |exception|
        if current_user.role == 'admin' then
            redirect_to admins_index_url
        elsif current_user.role == 'external' then
            redirect_to dashboard_index_url
        end
        flash[:error] = exception.message
    end

end