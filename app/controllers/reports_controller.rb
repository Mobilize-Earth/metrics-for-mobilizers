class ReportsController < ApplicationController
  def index
  end

  def tiles
  end

  def table
    @countries = ["USA"]
    render json: @countries
  end
end
