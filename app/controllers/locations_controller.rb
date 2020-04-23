class LocationsController < ApplicationController
  def states
    country_param = params[:country_code]
    country_code = CS.get.key(country_param)

    @states = CS.states(country_code)
    render json: {states: @states.to_a}
  end

  def cities
    country_param = params[:country_code]
    state_param = params[:state_code]

    country_code = CS.get.key(country_param)
    state_code = CS.states(country_code).key(state_param)

    @cities = CS.cities(state_code, country_code)
    render json: {cities: @cities.to_a}
  end
end
