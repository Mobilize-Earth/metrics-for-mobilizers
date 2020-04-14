class AdminsController < ApplicationController
    before_action :authenticate_user!

    def index
      @chapters = Chapter.all
      @users = User.all
      authorize! :index, AdminsController
    end
   
end