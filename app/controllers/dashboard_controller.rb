class DashboardController < ApplicationController

    def index
        authorize! :index, DashboardController
    end

end
