class ReportsController < ApplicationController
  def index
  end

  def tiles


    case params[:dateRange]

    when "week"
      report_data = {
          members_total: 1,
          members_growth: 7,
          subscriptions: 1000,
          arrestable_total: 1,
          arrestable_attrition: 7,
          arrests: 10
      }
    when "month"
      report_data = {
          members_total: 4,
          members_growth: 28,
          subscriptions: 4000,
          arrestable_total: 4,
          arrestable_attrition: 28,
          arrests: 40
      }
    when "quarter"
      report_data = {
          members_total: 12,
          members_growth: 84,
          subscriptions: 12000,
          arrestable_total: 12,
          arrestable_attrition: 84,
          arrests: 120
      }
    when "year"
      report_data = {
          members_total: 52,
          members_growth: 364,
          subscriptions: 52345,
          arrestable_total: 52,
          arrestable_attrition: 364,
          arrests: 520
      }
    end

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
