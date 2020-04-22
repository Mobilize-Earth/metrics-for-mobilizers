class FormsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :index, FormsController
  end
end
