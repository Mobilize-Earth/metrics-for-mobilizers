class AdminsController < ApplicationController
    before_action :authenticate_user!

    def index
      @chapters = Chapter.includes([:address])
      @users = User.includes([:chapter])
      authorize! :index, AdminsController
    end
end
