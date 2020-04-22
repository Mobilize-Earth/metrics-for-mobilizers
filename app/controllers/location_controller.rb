class LocationController < ApplicationController
  def show
    @countries = CS.get
    @states = []
  end

  def state
    country_code = params[:country_code]
    @states = CS.states(country_code)
    render json: {states: @states.to_a}
  end
end
