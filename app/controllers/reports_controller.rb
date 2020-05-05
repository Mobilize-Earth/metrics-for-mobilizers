class ReportsController < ApplicationController
  include Regions

  DATE_RANGE_MAPPING = {
      :week => 6,
      :month => 29,
      :quarter => 89,
      :'half-year' => 179
  }

  def index
    if params[:chapter]
      @chapter_name = Chapter.find(params[:chapter]).name
    end
  end

  def tiles
    country = params[:country]
    state = params[:state]
    region = params[:region]
    chapter_id = params[:chapter]
    date_range_days = DATE_RANGE_MAPPING[params[:dateRange].to_sym]

    if country.nil?
      chapters = Chapter.with_addresses.eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings)
      chapters_this_period = Chapter.with_addresses.
                             eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).
                             where('chapters.created_at BETWEEN ? AND ?' , (DateTime.now - date_range_days.days).beginning_of_day, DateTime.now.end_of_day)
    elsif country.upcase == 'US' && !region.nil? && state.nil?
      states = Regions.us_regions[region.to_sym][:states]
      chapters = Chapter.with_addresses
                        .eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).
                 where(addresses: {country: 'United States', state_province: states})
      chapters_this_period = Chapter.with_addresses.eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).
                             where(addresses: {country: 'United States', state_province: states}).
                             where('chapters.created_at BETWEEN ? AND ?' , (DateTime.now - date_range_days.days).beginning_of_day, DateTime.now.end_of_day)
    elsif state.nil?
      country = CS.countries[country.to_sym]
      chapters = Chapter.with_addresses.eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(addresses: {country: country})

      chapters_this_period = Chapter.with_addresses.
                             eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).
                             where(addresses: {country: country}).
                             where('chapters.created_at BETWEEN ? AND ?' , (DateTime.now - date_range_days.days).beginning_of_day, DateTime.now.end_of_day)

    elsif chapter_id.nil?
      state = validate_state(country, state)
      country = CS.countries[country.to_sym]
      chapters = Chapter.with_addresses.
                 eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).
                 where(addresses: {state_province: state, country: country})
      chapters_this_period = Chapter.
                             with_addresses.eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).
                             where(addresses: {state_province: state, country: country}).
                             where('chapters.created_at BETWEEN ? AND ?' , (DateTime.now - date_range_days.days).beginning_of_day, DateTime.now.end_of_day)
    else
      chapters = Chapter.with_addresses.
                 eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(id: chapter_id)
      chapters_this_period = Chapter.with_addresses.
                             eager_load(:mobilizations, :arrestable_actions, :street_swarms, :trainings).where(id: chapter_id).
                             where('chapters.created_at BETWEEN ? AND ?' , (DateTime.now - date_range_days.days).beginning_of_day, DateTime.now.end_of_day)
    end

    mobilizations_this_period = filter_mobilizations(chapters, date_range_days)
    previous_period_mobilizations = filter_mobilizations(chapters,
                                                         calculate_days_ago_for_previous_period(date_range_days),
                                                         (DateTime.now - date_range_days.days).beginning_of_day)

    filtered_trainings = filter_trainings(chapters, date_range_days)
    previous_period_trainings = filter_trainings(chapters,
                                                     calculate_days_ago_for_previous_period(date_range_days),
                                                     (DateTime.now - date_range_days.days).beginning_of_day)

    filtered_street_swarms = filter_street_swarms(chapters, date_range_days)
    previous_period_street_swarms = filter_street_swarms(chapters,
                                                 calculate_days_ago_for_previous_period(date_range_days),
                                                 (DateTime.now - date_range_days.days).beginning_of_day)

    filtered_arrestable_actions = filter_arrestable_actions(chapters, date_range_days)
    previous_period_arrestable_actions = filter_arrestable_actions(chapters,
                                                 calculate_days_ago_for_previous_period(date_range_days),
                                                 (DateTime.now - date_range_days.days).beginning_of_day)

    report_data = {
        chapters: chapters.count,
        chapters_growth: chapters_this_period.count,
        members: chapters.sum(&:active_members),
        members_growth: get_members_growth(chapters_this_period, mobilizations_this_period),
        subscriptions: chapters.sum(&:total_subscription_amount).to_int,
        subscriptions_growth: get_subscriptions_growth(chapters_this_period, mobilizations_this_period),
        mobilizations: mobilizations_this_period.length,
        mobilizations_growth: mobilizations_this_period.length - previous_period_mobilizations.length,
        signups: mobilizations_this_period.sum(&:xra_newsletter_sign_ups),
        signups_growth: mobilizations_this_period.sum(&:xra_newsletter_sign_ups) - previous_period_mobilizations.sum(&:xra_newsletter_sign_ups),
        trainings: filtered_trainings.length,
        trainings_growth: filtered_trainings.length - previous_period_trainings.length,
        pledges_arrestable: mobilizations_this_period.sum(&:arrestable_pledges),
        pledges_arrestable_growth: mobilizations_this_period.sum(&:arrestable_pledges) - previous_period_mobilizations.sum(&:arrestable_pledges),
        actions: filtered_street_swarms.length + filtered_arrestable_actions.length,
        actions_growth: (filtered_street_swarms.length + filtered_arrestable_actions.length) - (previous_period_street_swarms.length + previous_period_arrestable_actions.length),
        start_date: (DateTime.now - date_range_days.days).strftime("%d %B %Y"),
        end_date: DateTime.now.strftime("%d %B %Y")
    }

    render json: report_data
  end

  def mobilizations
    render json: {
        labels: get_chart_labels_for_period(params[:dateRange]),
        data: get_chart_data(params[:dateRange],
                             params[:country],
                             params[:region],
                             params[:state]
        )
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

  def get_members_growth(chapters_this_period, mobilizations_this_period)
    mobilizations_this_period.select { |m| chapters_this_period.map(&:id).exclude? m.chapter_id }.sum(&:new_members_sign_ons) +
        chapters_this_period.sum(&:active_members)
  end

  def get_subscriptions_growth(chapters_this_period, mobilizations_this_period)
    # TODO - We are currently using mobilizations.total_one_time_donations to calculate new subscriptions in a period.
    # We should update this DB column name to be total_donation_subscriptions instead.
    mobilizations_this_period.select { |m| chapters_this_period.map(&:id).exclude? m.chapter_id }.sum(&:total_one_time_donations).to_int +
        chapters_this_period.sum(&:total_subscription_amount).to_int
  end

  def calculate_days_ago_for_previous_period(date_range_days)
    date_range_days * 2 + 1
  end

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
          signups: filtered_mobilizations.sum(&:xra_newsletter_sign_ups),
          trainings: filtered_trainings.length,
          arrestable_pledges: filtered_mobilizations.sum(&:arrestable_pledges),
          actions: filtered_street_swarms.length + filtered_arrestable_actions.length,
          mobilizations: filtered_mobilizations.length,
          subscriptions: chapters.sum(&:total_subscription_amount).to_int
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
        result[:signups] = filtered_mobilizations.sum(&:xra_newsletter_sign_ups)
        result[:trainings] = filtered_trainings.length
        result[:arrestable_pledges] = filtered_mobilizations.sum(&:arrestable_pledges)
        result[:actions] = filtered_street_swarms.length + filtered_arrestable_actions.length
        result[:mobilizations] = filtered_mobilizations.length
        result[:subscriptions] =  chapters.sum(&:total_subscription_amount).to_int
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
          signups: filtered_mobilizations.sum(&:xra_newsletter_sign_ups),
          trainings: filtered_trainings.length,
          arrestable_pledges: filtered_mobilizations.sum(&:arrestable_pledges),
          actions: filtered_street_swarms.length + filtered_arrestable_actions.length,
          mobilizations: filtered_mobilizations.length,
          subscriptions: chapters.sum(&:total_subscription_amount).to_int
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
          signups: filtered_mobilizations.sum(&:xra_newsletter_sign_ups),
          trainings: filtered_trainings.length,
          arrestable_pledges: filtered_mobilizations.sum(&:arrestable_pledges),
          actions: filtered_street_swarms.length + filtered_arrestable_actions.length,
          mobilizations: filtered_mobilizations.length,
          subscriptions: chapters.sum(&:total_subscription_amount).to_int
      }
    end
  end

  def chapters(country, state, date_range_days)
    state = validate_state(country, state)
    country = CS.countries[country.to_sym]

    states_chapters = Chapter.with_addresses.
                      includes(:mobilizations, :arrestable_actions, :street_swarms, :trainings).
                      where(addresses: {country: country, state_province: state}).
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
          signups: filtered_mobilizations.sum(&:xra_newsletter_sign_ups),
          trainings: filtered_trainings.length,
          arrestable_pledges: filtered_mobilizations.sum(&:arrestable_pledges),
          actions: filtered_street_swarms.length + filtered_arrestable_actions.length,
          mobilizations: filtered_mobilizations.length,
          subscriptions: chapters.sum(&:total_subscription_amount).to_int
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
        signups: filtered_mobilizations.sum(&:xra_newsletter_sign_ups),
        trainings: filtered_trainings.length,
        arrestable_pledges: filtered_mobilizations.sum(&:arrestable_pledges),
        actions: filtered_street_swarms.length + filtered_arrestable_actions.length,
        mobilizations: filtered_mobilizations.length,
        subscriptions: chapter.total_subscription_amount.to_int
    }
    }
  end

  def validate_state(country, state)
    CS.states(country.to_sym)[CS.states(country.to_sym).key(state)]
  end

  def filter_mobilizations(chapters, date_range_days, end_date_range_days=DateTime.now.end_of_day)
    filtered_mobilizations = []
    chapters.each do |c|
      mobilizations = c.mobilizations.select { |m| m.created_at >= (DateTime.now - date_range_days.days).beginning_of_day && m.created_at <= end_date_range_days }
      filtered_mobilizations.append mobilizations
    end
    filtered_mobilizations.flatten
  end

  def filter_trainings(chapters, date_range_days, end_date_range_days=DateTime.now.end_of_day)
    result = []
    chapters.each do |c|
      trainings = c.trainings.select { |m| m.created_at >= (DateTime.now - date_range_days.days).beginning_of_day && m.created_at <= end_date_range_days }
      result.append trainings
    end
    result.flatten
  end

  def filter_street_swarms(chapters, date_range_days, end_date_range_days=DateTime.now.end_of_day)
    result = []
    chapters.each do |c|
      trainings = c.street_swarms.select { |m| m.created_at >= (DateTime.now - date_range_days.days).beginning_of_day && m.created_at <= end_date_range_days }
      result.append trainings
    end
    result.flatten
  end

  def filter_arrestable_actions(chapters, date_range_days, end_date_range_days=DateTime.now.end_of_day)
    result = []
    chapters.each do |c|
      trainings = c.arrestable_actions.select { |m| m.created_at >= (DateTime.now - date_range_days.days).beginning_of_day && m.created_at <= end_date_range_days }
      result.append trainings
    end
    result.flatten
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

  def get_chart_data(period, country_id, region_id, state)
    result = Mobilization.mobilization_type_options.map { |type| {
      label: type,
      new: get_array_of_empty_values(period),
      participants: get_array_of_empty_values(period),
      arrestable_pledges: get_array_of_empty_values(period),
      total_one_time_donations: get_array_of_empty_values(period),
    }}

    today = DateTime.now.end_of_day
    country = CS.countries[country_id.to_sym] unless country_id.nil?
    region = Regions.us_regions[region_id.to_sym] unless region_id.nil?
    states = region[:states] unless region.nil?
    states = [state] unless state.nil?

    case period
    when "month"
      get_mobilizations((DateTime.now - 6.days).beginning_of_day, today, result, 3, country, states)
      get_mobilizations((DateTime.now - 13.days).beginning_of_day, (DateTime.now - 7.days).end_of_day, result, 2, country, states)
      get_mobilizations((DateTime.now - 20.days).beginning_of_day, (DateTime.now - 14.days).end_of_day, result, 1, country, states)
      get_mobilizations((DateTime.now - 27.days).beginning_of_day, (DateTime.now - 21.days).end_of_day, result, 0, country, states)
    when "quarter"
      get_mobilizations(today.beginning_of_month, today, result, 2, country, states)
      get_mobilizations((DateTime.now - 1.months).beginning_of_month, (DateTime.now - 1.months).end_of_month, result, 1, country, states)
      get_mobilizations((DateTime.now - 2.months).beginning_of_month, (DateTime.now - 2.months).end_of_month, result, 0, country, states)
    when "half-year"
      get_mobilizations(today.beginning_of_month, today, result, 5, country, states)
      get_mobilizations((DateTime.now - 1.months).beginning_of_month, (DateTime.now - 1.months).end_of_month, result, 4, country, states)
      get_mobilizations((DateTime.now - 2.months).beginning_of_month, (DateTime.now - 2.months).end_of_month, result, 3, country, states)
      get_mobilizations((DateTime.now - 3.months).beginning_of_month, (DateTime.now - 3.months).end_of_month, result, 2, country, states)
      get_mobilizations((DateTime.now - 4.months).beginning_of_month, (DateTime.now - 4.months).end_of_month, result, 1, country, states)
      get_mobilizations((DateTime.now - 5.months).beginning_of_month, (DateTime.now - 5.months).end_of_month, result, 0, country, states)
    else
      get_mobilizations((DateTime.now - 6.days).beginning_of_day, today, result, 0, country, states)
    end

    result.sort! { |a,b| a[:label] <=> b[:label] }
  end

  def get_mobilizations(start_date, end_date, output, index, country, states)
    state_filter = {'addresses.state_province' => states} unless states.nil?
    country_filter = 'country=?' unless country.nil?
    Mobilization.left_outer_joins(:address)
                .where('mobilizations.created_at BETWEEN ? AND ?', start_date, end_date)
                .where(country_filter, country)
                .where(state_filter).each do |mobilization|
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
