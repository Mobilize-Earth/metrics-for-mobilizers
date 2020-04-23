class LocationController < ApplicationController
  def new
    @countries = CS.get
    @states = @cities = []
  end

  def edit
    @chapter = Chapter.first
    @countries = CS.get.collect{ |c| [c.second, c.first.to_s] }
    @states = @cities = []
  end

  def states
    country_code = params[:country_code]
    @states = CS.states(country_code)
    render json: {states: @states.to_a}
  end

  def cities
    country_code = params[:country_code]
    state_code = params[:state_code]
    @cities = CS.cities(state_code, country_code)
    render json: {cities: @cities.to_a}
  end
end
