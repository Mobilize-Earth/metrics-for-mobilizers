class FormsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :index, FormsController
    @chapter = current_user.chapter
  end
end
