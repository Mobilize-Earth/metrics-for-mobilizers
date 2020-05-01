class ReportsController < ApplicationController
  include Regions

  DATE_RANGE_MAPPING = {
      :week => 7,
      :month => 30,
      :quarter => 90,
      :'half-year' => 180
  }

  def index
  end

  def tiles
    country = params[:country]
    state = params[:state]
    region = params[:region]
    chapter_id = params[:chapter]

    query_string = if country.nil?
                     build_query_string("SELECT ", "")
                   elsif country.upcase == 'US' && !region.nil? && state.nil?
                     states = Regions.us_regions[region.to_sym][:states].map { |s| "'#{s}'" }.join(', ')
                     build_query_string("SELECT ", "WHERE addresses.country = 'United States' AND addresses.state_province IN (#{ActiveRecord::Base.sanitize_sql(states)})")
                   elsif state.nil?
                     country = CS.countries[country.to_sym]
                     build_query_string("SELECT ", "WHERE addresses.country = '#{ActiveRecord::Base.sanitize_sql(country)}'")
                   elsif chapter_id.nil?
                     state = validate_state(country, state)
                     build_query_string("SELECT ", "WHERE addresses.state_province = '#{ActiveRecord::Base.sanitize_sql(state)}'")
                   else
                     chapter = Chapter.find(chapter_id)
                     build_query_string("SELECT ", "WHERE chapters.id = '#{ActiveRecord::Base.sanitize_sql(chapter.id)}'")
                   end

    results = ActiveRecord::Base.connection.select_rows(query_string).flatten
    start_date_days = DATE_RANGE_MAPPING[params[:dateRange].to_sym]

    report_data = {
        members: results[0],
        chapters: results[1],
        trainings: results[3],
        pledges_arrestable: results[4],
        actions: results[5],
        mobilizations: results[6],
        subscriptions: results[7],
        start_date: (DateTime.now - start_date_days.days).strftime("%d %B %Y"),
        end_date: DateTime.now.strftime("%d %B %Y")
    }

    render json: report_data
  end

  def mobilizations
    render json: {
        labels: get_chart_labels_for_period(params[:dateRange]),
        data: get_chart_data_for_period(params[:dateRange])
    }
  end

  def table
    country = params[:country]
    state = params[:state]
    region = params[:region]
    chapter = params[:chapter]
    response = if country.nil?
                 all_countries
               elsif country.upcase == 'US' && region.nil?
                 us_regions
               elsif country.upcase == 'US' && !region.nil? && state.nil?
                 us_states(region)
               elsif state.nil?
                 states(country)
               elsif chapter.nil?
                 chapters(country, state)
               else
                 chapter_report(chapter)
               end
    render json: response
  end

  private

  def all_countries
    query_string = build_query_string("SELECT addresses.country as country, ", "GROUP BY addresses.country")

    results = ActiveRecord::Base.connection.select_rows(query_string)
    results.map do |result|
      country_name = result[0]
      {
          id: CS.countries.key(country_name),
          country: country_name,
          members: result[1],
          chapters: result[2],
          signups: result[3],
          trainings: result[4],
          arrestable_pledges: result[5],
          actions: result[6],
          mobilizations: result[7],
          subscriptions: result[8]
      }
    end
  end

  def us_regions
    Regions.us_regions.map do |k, v|
      states = v[:states].map { |s| "'#{s}'" }.join(', ')
      query_string = build_query_string("SELECT '#{k}' as region, ",
                                 "WHERE addresses.country = 'United States' AND addresses.state_province IN (#{ActiveRecord::Base.sanitize_sql(states)}) GROUP BY region")
      results = ActiveRecord::Base.connection.select_rows(query_string).flatten
      {
        id: k,
        region: v[:name],
        members: results[1],
        chapters: results[2],
        signups: results[3],
        trainings: results[4],
        arrestable_pledges: results[5],
        actions: results[6],
        mobilizations: results[7],
        subscriptions: results[8]
      }
    end
  end

  def us_states(region)
    states = Regions.us_regions[region.to_sym][:states].map { |s| "'#{s}'" }.join(', ')
    query_string = build_query_string("SELECT addresses.state_province as state, ",
                                      "WHERE addresses.country = 'United States' AND addresses.state_province IN (#{ActiveRecord::Base.sanitize_sql(states)}) GROUP BY state")
    results = ActiveRecord::Base.connection.select_rows(query_string)

    results.map do |result|
      state_name = result[0]
      {
          id: state_name,
          state: state_name,
          members: result[1],
          chapters: result[2],
          signups: result[3],
          trainings: result[4],
          arrestable_pledges: result[5],
          actions: result[6],
          mobilizations: result[7],
          subscriptions: result[8]
      }
    end
  end

  def states(country)
    country = CS.countries[country.to_sym]
    query_string = build_query_string("SELECT addresses.state_province as state, ",
                                      "WHERE addresses.country = '#{ActiveRecord::Base.sanitize_sql(country)}' GROUP BY state")

    results = ActiveRecord::Base.connection.select_rows(query_string)

    results.map do |result|
      state_name = result[0]
      {
          id: state_name,
          state: state_name,
          members: result[1],
          chapters: result[2],
          signups: result[3],
          trainings: result[4],
          arrestable_pledges: result[5],
          actions: result[6],
          mobilizations: result[7],
          subscriptions: result[8]
      }
    end
  end

  def chapters(country, state)
    state = validate_state(country, state)
    query_string = build_query_string("SELECT chapters.id, chapters.name as chapter, ",
                                      "WHERE addresses.state_province = '#{ActiveRecord::Base.sanitize_sql(state)}' GROUP BY id")

    results = ActiveRecord::Base.connection.select_rows(query_string)

    results.map do |result|
      {
          id: result[0],
          chapter: result[1],
          members: result[2],
          chapters: result[3],
          signups: result[4],
          trainings: result[5],
          arrestable_pledges: result[6],
          actions: result[7],
          mobilizations: result[8],
          subscriptions: result[9]
      }
    end
  end

  def validate_state(country, state)
    CS.states(country.to_sym)[CS.states(country.to_sym).key(state)]
  end

  def build_query_string(prepend_string, append_string)
    # Use Active Record prepared statements
    base_query = "SUM(DISTINCT(chapters.active_members)) as members,
                  COUNT(DISTINCT(chapters.id)) as chapters,
                  SUM(DISTINCT(mobilizations.new_members_sign_ons)) as signups,
                  COUNT(DISTINCT(trainings.id)) as trainings,
                  SUM(DISTINCT(mobilizations.arrestable_pledges)) as arrestable_pledges,
                  COUNT(DISTINCT(street_swarms.id)) + COUNT(DISTINCT(arrestable_actions.id)) as actions,
                  COUNT(DISTINCT(mobilizations.id)) as mobilizations,
                  SUM(DISTINCT(mobilizations.xra_donation_suscriptions)) as subscriptions
                  FROM chapters
                  LEFT JOIN addresses ON chapters.id = addresses.chapter_id
                  LEFT JOIN mobilizations ON chapters.id = mobilizations.chapter_id
                  LEFT JOIN street_swarms ON chapters.id = street_swarms.chapter_id
                  LEFT JOIN arrestable_actions ON chapters.id = arrestable_actions.chapter_id
                  LEFT JOIN trainings ON chapters.id = trainings.chapter_id "

    base_query.prepend(prepend_string)
    base_query << append_string
    base_query
  end


  def calculate_actions(name, type)
    case type
    when :country
      StreetSwarm.with_addresses.where(addresses: {country: name}).count +
          ArrestableAction.with_addresses.where(addresses: {country: name}).count
    when :state_province
      StreetSwarm.with_addresses.where(addresses: {state_province: name}).count +
          ArrestableAction.with_addresses.where(addresses: {state_province: name}).count
    when :chapter
      StreetSwarm.where(chapter: name).count + ArrestableAction.where(chapter: name).count
    end
  end

  def create_weekly_chart_label(days_ago)
    "Week ending #{(DateTime.now - days_ago.days).strftime("%d %B")}"
  end

  def chapter_report(id)
    chapter = Chapter.find(id)
    { result: { id: chapter.id,
        chapter: chapter.name,
        members: chapter.active_members,
        chapters: 1,
        signups: Mobilization.where(chapter: chapter).sum('new_members_sign_ons'),
        trainings: Training.where(chapter: chapter).count,
        arrestable_pledges: Mobilization.where(chapter: chapter).sum('arrestable_pledges'),
        actions: calculate_actions(chapter, :chapter),
        mobilizations: Mobilization.where(chapter: chapter).count,
        subscriptions: Mobilization.where(chapter: chapter).sum('xra_donation_suscriptions')
      }
    }
  end

  def create_monthly_chart_label(months_ago)
    "Month of #{(DateTime.now- months_ago.months).strftime("%B %Y")}"
  end

  def get_chart_labels_for_period(period)
    case period
    when "month"
      [create_weekly_chart_label(21), create_weekly_chart_label(14),
       create_weekly_chart_label(7), create_weekly_chart_label(0)]
    when "quarter"
      [create_monthly_chart_label(2), create_monthly_chart_label(1),
       create_monthly_chart_label(0)]
    when "half-year"
      [create_monthly_chart_label(5), create_monthly_chart_label(4),
       create_monthly_chart_label(3), create_monthly_chart_label(2),
       create_monthly_chart_label(1), create_monthly_chart_label(0)]
    else
      [create_weekly_chart_label(0)]
    end
  end

  def get_chart_data_for_period(period)
    result = Mobilization.mobilization_type_options.map { |type| {
      label: type,
      new: get_array_of_empty_values(period),
      participants: get_array_of_empty_values(period)
    }}

    today = DateTime.now.end_of_day

    case period
    when "month"
      get_mobilizations((DateTime.now - 6.days).beginning_of_day, today, result, 3)
      get_mobilizations((DateTime.now - 13.days).beginning_of_day, (DateTime.now - 7.days).end_of_day, result, 2)
      get_mobilizations((DateTime.now - 20.days).beginning_of_day, (DateTime.now - 14.days).end_of_day, result, 1)
      get_mobilizations((DateTime.now - 27.days).beginning_of_day, (DateTime.now - 21.days).end_of_day, result, 0)
    when "quarter"
      get_mobilizations(today.beginning_of_month, today, result, 2)
      get_mobilizations((DateTime.now - 1.months).beginning_of_month, (DateTime.now - 1.months).end_of_month, result, 1)
      get_mobilizations((DateTime.now - 2.months).beginning_of_month, (DateTime.now - 2.months).end_of_month, result, 0)
    when "half-year"
      get_mobilizations(today.beginning_of_month, today, result, 5)
      get_mobilizations((DateTime.now - 1.months).beginning_of_month, (DateTime.now - 1.months).end_of_month, result, 4)
      get_mobilizations((DateTime.now - 2.months).beginning_of_month, (DateTime.now - 2.months).end_of_month, result, 3)
      get_mobilizations((DateTime.now - 3.months).beginning_of_month, (DateTime.now - 3.months).end_of_month, result, 2)
      get_mobilizations((DateTime.now - 4.months).beginning_of_month, (DateTime.now - 4.months).end_of_month, result, 1)
      get_mobilizations((DateTime.now - 5.months).beginning_of_month, (DateTime.now - 5.months).end_of_month, result, 0)
    else
      get_mobilizations((DateTime.now - 6.days).beginning_of_day, today, result, 0)
    end

    result.sort! { |a,b| a[:label] <=> b[:label] }
  end

  def get_mobilizations(start_date, end_date, output, index)
    Mobilization.where('created_at BETWEEN ? AND ?', start_date, end_date).each do |mobilization|
      output.each do |chart_line|
        if chart_line[:label] == mobilization.mobilization_type
          chart_line[:new][index] = chart_line[:new][index] + mobilization.new_members_sign_ons
          chart_line[:participants][index] = chart_line[:participants][index] + mobilization.participants
        end
      end
    end
  end

  def get_array_of_empty_values(period)
    case period
    when "month"
      [0,0,0,0]
    when "quarter"
      [0,0,0]
    when "half-year"
      [0,0,0,0,0,0]
    else
      [0]
    end
  end
end
