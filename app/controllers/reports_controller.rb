class ReportsController < ApplicationController
  def index
  end

  def tiles
    case params[:dateRange]
    when "week"
      report_data = {
        members: 50,
        chapters: 7,
        actions: 100,
        trainings: 100,
        start_date: (DateTime.now - 7.days).strftime("%d %B %Y"),
        end_date: DateTime.now.strftime("%d %B %Y")
      }
    when "month"
      report_data = {
        members: 200,
        chapters: 28,
        actions: 400,
        trainings: 400,
        start_date: (DateTime.now - 30.days).strftime("%d %B %Y"),
        end_date: DateTime.now.strftime("%d %B %Y")
      }
    when "quarter"
      report_data = {
        members: 600,
        chapters: 84,
        actions: 1200,
        trainings: 1200,
        start_date: (DateTime.now - 90.days).strftime("%d %B %Y"),
        end_date: DateTime.now.strftime("%d %B %Y")
      }
    when "half-year"
      report_data = {
        members: 1200,
        chapters: 168,
        actions: 2400,
        trainings: 2400,
        start_date: (DateTime.now - 180.days).strftime("%d %B %Y"),
        end_date: DateTime.now.strftime("%d %B %Y")
      }
    end

    render json: report_data
  end

  def table
    country = params[:country]
    state = params[:state]
    response = if country.nil?
                 all_countries
               elsif state.nil?
                 get_states(country)
               else
                 get_chapters(state)
               end
    render json: response
  end

  private

  def all_countries
    countries = CS.countries.map { |k, v| { id: k, country: v, members: 0, chapters: 0, sign_ons: 0, trainings: 0, arrestable_pledges: 0, actions: 0 } }
    countries.find { |v| v[:country] == 'Ecuador' }[:members] = 223
    countries.find { |v| v[:country] == 'Mexico' }[:members] = 12
    countries.find { |v| v[:country] == 'United States' }[:members] = 12323
    countries
  end

  def get_states(country)
    CS.states(country).map { |k, v| { id: k, state: v, members: 0, chapters: 0, sign_ons: 0, trainings: 0, arrestable_pledges: 0, actions: 0 } }

  end

  def get_chapters(state)
    [
      { id: 1, chapter: 'Chapter 1', members: 20, chapters: 30, sign_ons: 10, trainings: 0, arrestable_pledges: 0, actions: 0 },
      { id: 2, chapter: 'Chapter 2', members: 420, chapters: 2, sign_ons: 310, trainings: 0, arrestable_pledges: 0, actions: 0 },
      { id: 3, chapter: 'Chapter 3', members: 43, chapters: 4, sign_ons: 233, trainings: 20, arrestable_pledges: 0, actions: 0 }
    ]
  end

end
