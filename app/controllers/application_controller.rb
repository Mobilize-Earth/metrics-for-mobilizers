class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :authenticate_user!

    def after_sign_in_path_for(resource)
        if current_user.role == 'admin' then
            admins_index_url
        elsif current_user.role == 'external' then
            chapter_url(current_user.chapter)
        end
    end

    rescue_from CanCan::AccessDenied do |exception|
        if current_user.role == 'admin' then
            redirect_to admins_index_url
        elsif current_user.role == 'external' then
            redirect_to chapter_url(current_user.chapter)
        end
        flash[:error] = exception.message
    end

end
