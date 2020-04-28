class ReportsController < ApplicationController
  include Regions

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
    region = params[:region]
    response = if country.nil?
                 all_countries
               elsif country.upcase == 'US' && region.nil?
                 mock_us_regions
               elsif country.upcase == 'US' && !region.nil? && state.nil?
                 mock_us_states(region)
               elsif state.nil?
                 mock_states(country)
               else
                 mock_chapters(state)
               end
    render json: response
  end

  private

  def mock_us_regions
    Regions.us_regions.map do |k, v|
      {
        id: k,
        region: v[:name],
        members: 0,
        chapters: 0,
        signups: 0,
        trainings: 0,
        arrestable_pledges: 0,
        actions: 0,
        mobilizations: 0,
        subscriptions: 0
      }
    end
  end

  def mock_us_states(region)
    Regions.us_regions[region.to_sym][:states].map do |v|
      {
        id: v,
        state: v,
        members: 0,
        chapters: 0,
        signups: 0,
        trainings: 0,
        arrestable_pledges: 0,
        actions: 0,
        mobilizations: 0,
        subscriptions: 0
      }
    end
  end

  def all_countries
    countries = CS.countries.map do |k, v|
      {
        id: k,
        country: v,
        members: 0,
        chapters: 0,
        signups: 0,
        trainings: 0,
        arrestable_pledges: 0,
        actions: 0,
        mobilizations: 0,
        subscriptions: 0
      }
    end
    countries.find { |v| v[:country] == 'Ecuador' }[:members] = 223
    countries.find { |v| v[:country] == 'Mexico' }[:members] = 12
    countries.find { |v| v[:country] == 'United States' }[:members] = 12323
    countries
  end

  def mock_states(country)
    CS.states(country).map do |k, v|
      {
        id: k,
        state: v,
        members: 0,
        chapters: 0,
        signups: 0,
        trainings: 0,
        arrestable_pledges: 0,
        actions: 0,
        mobilizations: 0,
        subscriptions: 0
      }
    end
  end

  def mock_chapters(state)
    [
      { id: 1, chapter: 'Chapter 1',
        members: 20,
        chapters: 1,
        signups: 0,
        trainings: 0,
        arrestable_pledges: 0,
        actions: 0,
        mobilizations: 0,
        subscriptions: 0 },
      { id: 2, chapter: 'Chapter 2',
        members: 420,
        chapters: 1,
        signups: 0,
        trainings: 0,
        arrestable_pledges: 0,
        actions: 0,
        mobilizations: 0,
        subscriptions: 0 },
      { id: 3, chapter: 'Chapter 3',
        members: 43,
        chapters: 1,
        signups: 0,
        trainings: 0,
        arrestable_pledges: 0,
        actions: 0,
        mobilizations: 0,
        subscriptions: 0 }
    ]
  end

end
