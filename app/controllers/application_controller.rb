class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :authenticate_user!
    skip_before_action :authenticate_user!, :only => [:index]

    def after_sign_in_path_for(resource)
        if @user.rol == 0 then
            admins_index_url
        elsif @user.rol == 1 then
            dashboard_index_url
        end
    end
end