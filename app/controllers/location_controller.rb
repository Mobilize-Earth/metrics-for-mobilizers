class LocationController < ApplicationController
  def show
    @countries = CS.get
  end
end
