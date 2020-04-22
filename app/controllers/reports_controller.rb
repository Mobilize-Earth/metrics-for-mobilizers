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
    countries = [{ country: "USA", members: 13 },
                  { country: "Mexico", members: 12 },
                  { country: "Ecuador", members: 543 }]
    render json: countries
  end
end
