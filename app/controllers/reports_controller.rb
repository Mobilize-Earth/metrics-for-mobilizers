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
                     Chapter.with_addresses.includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings)
                   elsif country.upcase == 'US' && !region.nil? && state.nil?
                     states = Regions.us_regions[region.to_sym][:states]
                     Chapter.with_addresses.includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(addresses: {state_province: states})
                   elsif state.nil?
                     country = CS.countries[country.to_sym]
                     Chapter.with_addresses.includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(addresses: {country: country})
                   elsif chapter_id.nil?
                     state = validate_state(country, state)
                     Chapter.with_addresses.includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(addresses: {state_province: state})
                   else
                     [Chapter.find(chapter_id)]
                   end

    report_data = {
        members: chapters.sum(&:active_members),
        chapters: chapters.count,
        signups: (chapters.map {|chapter| chapter.mobilizations.sum(&:new_members_sign_ons)}).sum,
        trainings: (chapters.map {|chapter| chapter.trainings.length}).sum,
        pledges_arrestable: (chapters.map {|chapter| chapter.mobilizations.sum(&:arrestable_pledges)}).sum,
        actions: (chapters.map {|chapter| chapter.street_swarms.length + chapter.arrestable_actions.length}).sum,
        mobilizations: (chapters.map {|chapter| chapter.mobilizations.length}).sum,
        subscriptions: (chapters.map {|chapter| chapter.mobilizations.sum(&:xra_donation_suscriptions)}).sum,
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
                                        chapter_report(chapter)
                                      end
      render json: response
    rescue
      render json: {error: true}
    end
  end

  private

  def all_countries(date_range_days)
    addresses_with_chapters = Chapter.with_addresses.includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).group_by { |c| c.address.country }

    addresses_with_chapters.map do |country|
      chapters = country[1]
      {
          id: CS.countries.key(country[0]),
          country: country[0],
          members: chapters.sum(&:active_members),
          chapters: chapters.count,
          signups: (chapters.map {|chapter| chapter.mobilizations.sum(&:new_members_sign_ons)}).sum,
          trainings: (chapters.map {|chapter| chapter.trainings.length}).sum,
          arrestable_pledges: (chapters.map {|chapter| chapter.mobilizations.sum(&:arrestable_pledges)}).sum,
          actions: (chapters.map {|chapter| chapter.street_swarms.length + chapter.arrestable_actions.length}).sum,
          mobilizations: (chapters.map {|chapter| chapter.mobilizations.length}).sum,
          subscriptions: (chapters.map {|chapter| chapter.mobilizations.sum(&:xra_donation_suscriptions)}).sum
      }
    end
  end

  def us_regions(date_range_days)
    Regions.us_regions.map do |k, v|
      result = {
          id: k,
          region: v[:name],
      }
      region_chapters = Chapter.with_addresses.includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(addresses: {state_province: v[:states]}).group_by { |c| c.address.country }
      region_chapters.map do |country|
        chapters = country[1]
        result[:members] = chapters.sum(&:active_members)
        result[:chapters] = chapters.count
        result[:signups] = (chapters.map {|chapter| chapter.mobilizations.sum(&:new_members_sign_ons)}).sum
        result[:trainings] = (chapters.map {|chapter| chapter.trainings.length}).sum
        result[:arrestable_pledges] = (chapters.map {|chapter| chapter.mobilizations.sum(&:arrestable_pledges)}).sum
        result[:actions] = (chapters.map {|chapter| chapter.street_swarms.length + chapter.arrestable_actions.length}).sum
        result[:mobilizations] = (chapters.map {|chapter| chapter.mobilizations.length}).sum
        result[:subscriptions] =  (chapters.map {|chapter| chapter.mobilizations.sum(&:xra_donation_suscriptions)}).sum
      end
      result
    end
  end

  def us_states(region, date_range_days)
    states = Regions.us_regions[region.to_sym][:states]
    states_with_chapters = Chapter.with_addresses.includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(addresses: {state_province: states}).group_by { |c| c.address.state_province }

    states_with_chapters.map do |state|
      chapters = state[1]
      {
          id: state[0],
          state: state[0],
          members: chapters.sum(&:active_members),
          chapters: chapters.count,
          signups: (chapters.map {|chapter| chapter.mobilizations.sum(&:new_members_sign_ons)}).sum,
          trainings: (chapters.map {|chapter| chapter.trainings.length}).sum,
          arrestable_pledges: (chapters.map {|chapter| chapter.mobilizations.sum(&:arrestable_pledges)}).sum,
          actions: (chapters.map {|chapter| chapter.street_swarms.length + chapter.arrestable_actions.length}).sum,
          mobilizations: (chapters.map {|chapter| chapter.mobilizations.length}).sum,
          subscriptions: (chapters.map {|chapter| chapter.mobilizations.sum(&:xra_donation_suscriptions)}).sum
      }
    end
  end

  def states(country, date_range_days)
    country = CS.countries[country.to_sym]
    states_with_chapters = Chapter.with_addresses.includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(addresses: {country: country}).group_by { |c| c.address.state_province }

    states_with_chapters.map do |state|
      chapters = state[1]
      {
          id: state[0],
          state: state[0],
          members: chapters.sum(&:active_members),
          chapters: chapters.count,
          signups: (chapters.map {|chapter| chapter.mobilizations.sum(&:new_members_sign_ons)}).sum,
          trainings: (chapters.map {|chapter| chapter.trainings.length}).sum,
          arrestable_pledges: (chapters.map {|chapter| chapter.mobilizations.sum(&:arrestable_pledges)}).sum,
          actions: (chapters.map {|chapter| chapter.street_swarms.length + chapter.arrestable_actions.length}).sum,
          mobilizations: (chapters.map {|chapter| chapter.mobilizations.length}).sum,
          subscriptions: (chapters.map {|chapter| chapter.mobilizations.sum(&:xra_donation_suscriptions)}).sum
      }
    end
  end

  def chapters(country, state, date_range_days)
    state = validate_state(country, state)

    states_chapters = Chapter.with_addresses.includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(addresses: {state_province: state}).group_by { |c| c.id }
    states_chapters.map do |chapter|
      chapter = chapter[1][0]
      {
          id: chapter.id,
          chapter: chapter.name,
          members: chapter.active_members,
          chapters: 1,
          signups: chapter.mobilizations.sum(&:new_members_sign_ons),
          trainings: chapter.trainings.length,
          arrestable_pledges: chapter.mobilizations.sum(&:arrestable_pledges),
          actions: chapter.street_swarms.length + chapter.arrestable_actions.length,
          mobilizations: chapter.mobilizations.length,
          subscriptions: chapter.mobilizations.sum(&:xra_donation_suscriptions)
      }
    end
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
