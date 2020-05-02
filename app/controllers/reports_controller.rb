class ReportsController < ApplicationController
  include Regions

  DATE_RANGE_MAPPING = {
      :week => 6,
      :month => 29,
      :quarter => 89,
      :'half-year' => 179
  }

  def index
  end

  def tiles
    country = params[:country]
    state = params[:state]
    region = params[:region]
    chapter_id = params[:chapter]
    date_range_days = DATE_RANGE_MAPPING[params[:dateRange].to_sym]

    chapters = if country.nil?
                 Chapter.with_addresses.eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings)
               elsif country.upcase == 'US' && !region.nil? && state.nil?
                 states = Regions.us_regions[region.to_sym][:states]
                 Chapter.with_addresses.eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(addresses: {country: 'United States', state_province: states})
               elsif state.nil?
                 country = CS.countries[country.to_sym]
                 Chapter.with_addresses.eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(addresses: {country: country})

               elsif chapter_id.nil?
                 state = validate_state(country, state)
                 Chapter.with_addresses.eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(addresses: {state_province: state})
               else
                 Chapter.with_addresses.eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(id: chapter_id)
               end
    filtered_mobilizations = filter_mobilizations(chapters, date_range_days)
    filtered_trainings = filter_trainings(chapters, date_range_days)
    filtered_street_swarms = filter_street_swarms(chapters, date_range_days)
    filtered_arrestable_actions = filter_arrestable_actions(chapters, date_range_days)

    report_data = {
        members: chapters.sum(&:active_members),
        chapters: chapters.count,
        signups: filtered_mobilizations.sum(&:new_members_sign_ons),
        trainings: filtered_trainings.length,
        pledges_arrestable: filtered_mobilizations.sum(&:arrestable_pledges),
        actions: filtered_street_swarms.length + filtered_arrestable_actions.length,
        mobilizations: filtered_mobilizations.length,
        subscriptions: filtered_mobilizations.sum(&:xra_donation_suscriptions),
        start_date: (DateTime.now - date_range_days.days).strftime("%d %B %Y"),
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
    date_range_days = DATE_RANGE_MAPPING[params[:period].to_sym]
    begin
      response = if country.nil?
                   all_countries(date_range_days)
                 elsif country.upcase == 'US' && region.nil?
                   us_regions(date_range_days)
                 elsif country.upcase == 'US' && !region.nil? && state.nil?
                   us_states(region, date_range_days)
                 elsif state.nil?
                   states(country, date_range_days)
                 elsif chapter.nil?
                   chapters(country, state, date_range_days)
                 else
                   chapter_report(chapter, date_range_days)
                 end
      render json: response
    rescue
      render json: {error: true}
    end
  end

  private

  def all_countries(date_range_days)

    addresses_with_chapters = Chapter.with_addresses.
        eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).
        group_by { |c| c.address.country }

    addresses_with_chapters.map do |country|
      chapters = country[1]

      filtered_mobilizations = filter_mobilizations(chapters, date_range_days)
      filtered_trainings = filter_trainings(chapters, date_range_days)
      filtered_street_swarms = filter_street_swarms(chapters, date_range_days)
      filtered_arrestable_actions = filter_arrestable_actions(chapters, date_range_days)

      {
          id: CS.countries.key(country[0]),
          country: country[0],
          members: chapters.sum(&:active_members),
          chapters: chapters.count,
          signups: filtered_mobilizations.sum(&:new_members_sign_ons),
          trainings: filtered_trainings.length,
          arrestable_pledges: filtered_mobilizations.sum(&:arrestable_pledges),
          actions: filtered_street_swarms.length + filtered_arrestable_actions.length,
          mobilizations: filtered_mobilizations.length,
          subscriptions: filtered_mobilizations.sum(&:xra_donation_suscriptions)
      }
    end
  end

  def us_regions(date_range_days)
    Regions.us_regions.map do |k, v|
      result = {
          id: k,
          region: v[:name],
      }

      region_chapters = Chapter.with_addresses.
          includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).
          where(addresses: {country: 'United States', state_province: v[:states]}).
          group_by { |c| c.address.country }

      region_chapters.map do |country|
        chapters = country[1]
        filtered_mobilizations = filter_mobilizations(chapters, date_range_days)
        filtered_trainings = filter_trainings(chapters, date_range_days)
        filtered_street_swarms = filter_street_swarms(chapters, date_range_days)
        filtered_arrestable_actions = filter_arrestable_actions(chapters, date_range_days)

        result[:members] = chapters.sum(&:active_members)
        result[:chapters] = chapters.count
        result[:signups] = filtered_mobilizations.sum(&:new_members_sign_ons)
        result[:trainings] = filtered_trainings.length
        result[:arrestable_pledges] = filtered_mobilizations.sum(&:arrestable_pledges)
        result[:actions] = filtered_street_swarms.length + filtered_arrestable_actions.length
        result[:mobilizations] = filtered_mobilizations.length
        result[:subscriptions] =  filtered_mobilizations.sum(&:xra_donation_suscriptions)
      end
      result
    end
  end

  def us_states(region, date_range_days)
    states = Regions.us_regions[region.to_sym][:states]
    states_with_chapters = Chapter.with_addresses.
        includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).
        where(addresses: {country: 'United States', state_province: states}).
        group_by { |c| c.address.state_province }

    states_with_chapters.map do |state|
      chapters = state[1]

      filtered_mobilizations = filter_mobilizations(chapters, date_range_days)
      filtered_trainings = filter_trainings(chapters, date_range_days)
      filtered_street_swarms = filter_street_swarms(chapters, date_range_days)
      filtered_arrestable_actions = filter_arrestable_actions(chapters, date_range_days)

      {
          id: state[0],
          state: state[0],
          members: chapters.sum(&:active_members),
          chapters: chapters.count,
          signups: filtered_mobilizations.sum(&:new_members_sign_ons),
          trainings: filtered_trainings.length,
          arrestable_pledges: filtered_mobilizations.sum(&:arrestable_pledges),
          actions: filtered_street_swarms.length + filtered_arrestable_actions.length,
          mobilizations: filtered_mobilizations.length,
          subscriptions: filtered_mobilizations.sum(&:xra_donation_suscriptions)
      }
    end
  end

  def states(country, date_range_days)
    country = CS.countries[country.to_sym]
    states_with_chapters = Chapter.with_addresses.
        includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).
        where(addresses: {country: country}).
        group_by { |c| c.address.state_province }

    states_with_chapters.map do |state|
      chapters = state[1]
      filtered_mobilizations = filter_mobilizations(chapters, date_range_days)
      filtered_trainings = filter_trainings(chapters, date_range_days)
      filtered_street_swarms = filter_street_swarms(chapters, date_range_days)
      filtered_arrestable_actions = filter_arrestable_actions(chapters, date_range_days)
      {
          id: state[0],
          state: state[0],
          members: chapters.sum(&:active_members),
          chapters: chapters.count,
          signups: filtered_mobilizations.sum(&:new_members_sign_ons),
          trainings: filtered_trainings.length,
          arrestable_pledges: filtered_mobilizations.sum(&:arrestable_pledges),
          actions: filtered_street_swarms.length + filtered_arrestable_actions.length,
          mobilizations: filtered_mobilizations.length,
          subscriptions: filtered_mobilizations.sum(&:xra_donation_suscriptions)
      }
    end
  end

  def chapters(country, state, date_range_days)
    state = validate_state(country, state)

    states_chapters = Chapter.with_addresses.
        includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).
        where(addresses: {state_province: state}).
        group_by { |c| c.id }

    states_chapters.map do |chapter|
      chapter = chapter[1][0]
      chapters = [chapter]

      filtered_mobilizations = filter_mobilizations(chapters, date_range_days)
      filtered_trainings = filter_trainings(chapters, date_range_days)
      filtered_street_swarms = filter_street_swarms(chapters, date_range_days)
      filtered_arrestable_actions = filter_arrestable_actions(chapters, date_range_days)
      {
          id: chapter.id,
          chapter: chapter.name,
          members: chapter.active_members,
          chapters: 1,
          signups: filtered_mobilizations.sum(&:new_members_sign_ons),
          trainings: filtered_trainings.length,
          arrestable_pledges: filtered_mobilizations.sum(&:arrestable_pledges),
          actions: filtered_street_swarms.length + filtered_arrestable_actions.length,
          mobilizations: filtered_mobilizations.length,
          subscriptions: filtered_mobilizations.sum(&:xra_donation_suscriptions)
      }
    end
  end

  def chapter_report(id, date_range_days)
    chapter = Chapter.find(id)
    chapters = [chapter]

    filtered_mobilizations = filter_mobilizations(chapters, date_range_days)
    filtered_trainings = filter_trainings(chapters, date_range_days)
    filtered_street_swarms = filter_street_swarms(chapters, date_range_days)
    filtered_arrestable_actions = filter_arrestable_actions(chapters, date_range_days)

    { result: {
        id: chapter.id,
        chapter: chapter.name,
        members: chapter.active_members,
        chapters: 1,
        signups: filtered_mobilizations.sum(&:new_members_sign_ons),
        trainings: filtered_trainings.length,
        arrestable_pledges: filtered_mobilizations.sum(&:arrestable_pledges),
        actions: filtered_street_swarms.length + filtered_arrestable_actions.length,
        mobilizations: filtered_mobilizations.length, subscriptions: filtered_mobilizations.sum(&:xra_donation_suscriptions)
    }
    }
  end

  def validate_state(country, state)
    CS.states(country.to_sym)[CS.states(country.to_sym).key(state)]
  end

  def build_start_of_day_timestamp(date_range_days)
    (Time.now - date_range_days.day).beginning_of_day.utc.strftime('%Y-%m-%d %H:%M:%S')
  end

  def build_end_of_day_timestamp(date_range_days)
    Time.now.end_of_day.utc.strftime('%Y-%m-%d %H:%M:%S')
  end

  def filter_mobilizations(chapters, date_range_days)
    filtered_mobilizations = []
    chapters.each do |c|
      mobilizations = c.mobilizations.select { |m| m.created_at >= (DateTime.now - date_range_days.days).beginning_of_day }
      filtered_mobilizations.append mobilizations
    end
    filtered_mobilizations.flatten
  end

  def filter_trainings(chapters, date_range_days)
    result = []
    chapters.each do |c|
      trainings = c.trainings.select { |m| m.created_at >= (DateTime.now - date_range_days.days).beginning_of_day }
      result.append trainings
    end
    result.flatten
  end

  def filter_street_swarms(chapters, date_range_days)
    result = []
    chapters.each do |c|
      trainings = c.street_swarms.select { |m| m.created_at >= (DateTime.now - date_range_days.days).beginning_of_day }
      result.append trainings
    end
    result.flatten
  end

  def filter_arrestable_actions(chapters, date_range_days)
    result = []
    chapters.each do |c|
      trainings = c.arrestable_actions.select { |m| m.created_at >= (DateTime.now - date_range_days.days).beginning_of_day }
      result.append trainings
    end
    result.flatten
  end

  def append_date_range_to_query(query, date_range_days)
    today =  DateTime.now.end_of_day
    start_day = (DateTime.now - date_range_days.days).beginning_of_day
    query.
        where('mobilizations.created_at BETWEEN ? AND ?', start_day, today).
        where('arrestable_actions.created_at BETWEEN ? AND ?', start_day, today).
        where('street_swarms.created_at BETWEEN ? AND ?', start_day, today).
        where('trainings.created_at BETWEEN ? AND ?', start_day, today)
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
      participants: get_array_of_empty_values(period),
      arrestable_pledges: get_array_of_empty_values(period),
      total_one_time_donations: get_array_of_empty_values(period),
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
          chart_line[:arrestable_pledges][index] = chart_line[:arrestable_pledges][index] + mobilization.arrestable_pledges
          chart_line[:total_one_time_donations][index] = chart_line[:total_one_time_donations][index] + mobilization.total_one_time_donations
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
