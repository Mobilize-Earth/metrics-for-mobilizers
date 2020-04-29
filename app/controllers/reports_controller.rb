class ReportsController < ApplicationController
  include Regions

  def index
  end

  def tiles
    case params[:dateRange]
    when "week"
      report_data = {
          members: Chapter.sum('active_members'),
          chapters: Chapter.count,
          actions: StreetSwarm.count + ArrestableAction.count,
          trainings: Training.count,
          mobilizations: Mobilization.count,
          pledges_arrestable: Mobilization.sum('arrestable_pledges'),
          subscriptions: Mobilization.sum('xra_donation_suscriptions'),
          start_date: (DateTime.now - 7.days).strftime("%d %B %Y"),
          end_date: DateTime.now.strftime("%d %B %Y")
      }
    when "month"
      report_data = {
          members: Chapter.sum('active_members'),
          chapters: Chapter.count,
          actions: StreetSwarm.count + ArrestableAction.count,
          trainings: Training.count,
          mobilizations: Mobilization.count,
          pledges_arrestable: Mobilization.sum('arrestable_pledges'),
          subscriptions: Mobilization.sum('xra_donation_suscriptions'),
          start_date: (DateTime.now - 30.days).strftime("%d %B %Y"),
          end_date: DateTime.now.strftime("%d %B %Y")
      }
    when "quarter"
      report_data = {
          members: Chapter.sum('active_members'),
          chapters: Chapter.count,
          actions: StreetSwarm.count + ArrestableAction.count,
          trainings: Training.count,
          mobilizations: Mobilization.count,
          pledges_arrestable: Mobilization.sum('arrestable_pledges'),
          subscriptions: Mobilization.sum('xra_donation_suscriptions'),
          start_date: (DateTime.now - 90.days).strftime("%d %B %Y"),
          end_date: DateTime.now.strftime("%d %B %Y")
      }
    when "half-year"
      report_data = {
          members: Chapter.sum('active_members'),
          chapters: Chapter.count,
          actions: StreetSwarm.count + ArrestableAction.count,
          trainings: Training.count,
          mobilizations: Mobilization.count,
          pledges_arrestable: Mobilization.sum('arrestable_pledges'),
          subscriptions: Mobilization.sum('xra_donation_suscriptions'),
          start_date: (DateTime.now - 180.days).strftime("%d %B %Y"),
          end_date: DateTime.now.strftime("%d %B %Y")
      }
    end

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
    response = if country.nil?
                 all_countries
               elsif country.upcase == 'US' && region.nil?
                 us_regions
               elsif country.upcase == 'US' && !region.nil? && state.nil?
                 us_states(region)
               elsif state.nil?
                 states(country)
               else
                 chapters(state)
               end
    render json: response
  end

  private

  def us_regions
    Regions.us_regions.map do |k, v|
      {
        id: k,
        region: v[:name],
        members: Chapter.with_addresses.where(addresses: {state_province: v[:states] }).sum('active_members'),
        chapters: Chapter.with_addresses.where(addresses: {state_province: v[:states]}).count,
        signups: Mobilization.with_addresses.where(addresses: {state_province: v[:states]}).sum('new_members_sign_ons'),
        trainings: Training.with_addresses.where(addresses: {state_province: v[:states]}).count,
        arrestable_pledges: Mobilization.with_addresses.where(addresses: {state_province: v[:states]}).sum('arrestable_pledges'),
        actions: calculate_actions(v[:states], :state_province),
        mobilizations: Mobilization.with_addresses.where(addresses: {state_province: v[:states]}).count,
        subscriptions: Mobilization.with_addresses.where(addresses: {state_province: v[:states]}).sum('xra_donation_suscriptions')
      }
    end
  end

  def us_states(region)
    Regions.us_regions[region.to_sym][:states].map do |v|
      {
        id: v,
        state: v,
        members: Chapter.with_addresses.where(addresses: {state_province: v}).sum('active_members'),
        chapters: Chapter.with_addresses.where(addresses: {state_province: v}).count,
        signups: Mobilization.with_addresses.where(addresses: {state_province: v}).sum('new_members_sign_ons'),
        trainings: Training.with_addresses.where(addresses: {state_province: v}).count,
        arrestable_pledges: Mobilization.with_addresses.where(addresses: {state_province: v}).sum('arrestable_pledges'),
        actions: calculate_actions(v, :state_province),
        mobilizations: Mobilization.with_addresses.where(addresses: {state_province: v}).count,
        subscriptions: Mobilization.with_addresses.where(addresses: {state_province: v}).sum('xra_donation_suscriptions')
      }
    end
  end

  def all_countries
    CS.countries.map do |k, v|
      {
        id: k,
        country: v,
        members: Chapter.with_addresses.where(addresses: {country: v}).sum('active_members'),
        chapters: Chapter.with_addresses.where(addresses: {country: v}).count,
        signups: Mobilization.with_addresses.where(addresses: {country: v}).sum('new_members_sign_ons'),
        trainings: Training.with_addresses.where(addresses: {country: v}).count,
        arrestable_pledges: Mobilization.with_addresses.where(addresses: {country: v}).sum('arrestable_pledges'),
        actions: calculate_actions(v, :country),
        mobilizations: Mobilization.with_addresses.where(addresses: {country: v}).count,
        subscriptions: Mobilization.with_addresses.where(addresses: {country: v}).sum('xra_donation_suscriptions')
      }
    end
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

  def states(country)
    CS.states(country).map do |k, v|
      {
        id: k,
        state: v,
        members: Chapter.with_addresses.where(addresses: {state_province: v}).sum('active_members'),
        chapters: Chapter.with_addresses.where(addresses: {state_province: v}).count,
        signups: Mobilization.with_addresses.where(addresses: {state_province: v}).sum('new_members_sign_ons'),
        trainings: Training.with_addresses.where(addresses: {state_province: v}).count,
        arrestable_pledges: Mobilization.with_addresses.where(addresses: {state_province: v}).sum('arrestable_pledges'),
        actions: calculate_actions(v, :state_province),
        mobilizations: Mobilization.with_addresses.where(addresses: {state_province: v}).count,
        subscriptions: Mobilization.with_addresses.where(addresses: {state_province: v}).sum('xra_donation_suscriptions')
      }
    end
  end

  def chapters(state)
    chapters_in_state = Chapter.with_addresses.where(addresses: {state_province: state})
    chapters_in_state.map do |chapter|
      { id: chapter.id,
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
      [create_weekly_chart_label(0), create_weekly_chart_label(7),
       create_weekly_chart_label(14), create_weekly_chart_label(21)]
    when "quarter"
      [create_monthly_chart_label(0), create_monthly_chart_label(1),
       create_monthly_chart_label(2)]
    when "half-year"
      [create_monthly_chart_label(0), create_monthly_chart_label(1),
       create_monthly_chart_label(2), create_monthly_chart_label(3),
       create_monthly_chart_label(4), create_monthly_chart_label(5)]
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

    case period
    when "month"
      get_mobilizations((DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day, result, 0)
      get_mobilizations((DateTime.now - 13.days).beginning_of_day, (DateTime.now - 7.days).end_of_day, result, 1)
      get_mobilizations((DateTime.now - 20.days).beginning_of_day, (DateTime.now - 14.days).end_of_day, result, 2)
      get_mobilizations((DateTime.now - 27.days).beginning_of_day, (DateTime.now - 21.days).end_of_day, result, 3)
    when "quarter"
      get_mobilizations((DateTime.now - 1.months).end_of_day, DateTime.now.end_of_day, result, 0)
      get_mobilizations((DateTime.now - 2.months).beginning_of_day, (DateTime.now - 1.months).end_of_day, result, 1)
      get_mobilizations((DateTime.now - 3.months).beginning_of_day, (DateTime.now - 2.months).end_of_day, result, 2)
    when "half-year"
      get_mobilizations((DateTime.now - 1.months).end_of_day, DateTime.now.end_of_day, result, 0)
      get_mobilizations((DateTime.now - 2.months).beginning_of_day, (DateTime.now - 1.months).end_of_day, result, 1)
      get_mobilizations((DateTime.now - 3.months).beginning_of_day, (DateTime.now - 2.months).end_of_day, result, 2)
      get_mobilizations((DateTime.now - 4.months).beginning_of_day, (DateTime.now - 3.months).end_of_day, result, 2)
      get_mobilizations((DateTime.now - 5.months).beginning_of_day, (DateTime.now - 4.months).end_of_day, result, 2)
      get_mobilizations((DateTime.now - 6.months).beginning_of_day, (DateTime.now - 5.months).end_of_day, result, 2)
    else
      get_mobilizations((DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day, result, 0)
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
