class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
        authorize! :index, DashboardController
    end

end
