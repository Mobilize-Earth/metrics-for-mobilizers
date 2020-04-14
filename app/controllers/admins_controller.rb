class AdminsController < ApplicationController
    protect_from_forgery with: :exception

    before_action :authenticate_user!

    def index
      @chapters = Chapter.all
      @users = User.all
    end
end
