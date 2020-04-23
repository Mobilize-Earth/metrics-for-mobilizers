class ReportsController < ApplicationController
  def index
  end

  def tiles
    report_data = {
      members_total: 1,
      members_growth: 7,
      subscriptions: 1000,
      arrestable_total: 1,
      arrestable_attrition: 7,
      arrests: 10
    }
    render json: report_data
  end

  def table
    country = params[:country]
    response = if country.nil?
                 all_countries
               else
                 by_country(country)
               end
    render json: response
  end

  private

  def all_countries
    countries = CS.countries.map { |k, v| { id: k, country: v, members: 0 } }
    countries.find { |v| v[:country] == 'Ecuador' }[:members] = 223
    countries.find { |v| v[:country] == 'Mexico' }[:members] = 12
    countries.find { |v| v[:country] == 'United States' }[:members] = 12323
    countries
  end

  def by_country(country)
    CS.states(country).map { |k, v| { id: k, state: v, members: 0 } }
  end

end
