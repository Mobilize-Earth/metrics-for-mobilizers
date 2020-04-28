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
    report_data = {
        labels: ["Week of " + DateTime.now.strftime("%d %B")],
        data: [
            {label: 'H4E Presentations', participants: [2], new: [1]},
            {label: 'Rebel Ringing', participants: [4], new: [2]},
            {label: 'House Meetings', participants: [3], new: [2]},
            {label: 'Fly Posting / Chalking', participants: [11], new: [5]},
            {label: 'Door Knocking', participants: [6], new: [1]},
            {label: 'Street Stalls', participants: [5], new: [0]},
            {label: 'Leafleting', participants: [3], new: [0]},
            {label: '1:1 Recruiting / Other', participants: [7], new: [5]},
        ],
        metrics: [
            {label: '#metric-h4e', value: 90, visualLabel: '#visual-h4e'},
            {label: '#metric-rebel-ringing', value: 75, visualLabel: '#visual-rebel-ringing'},
            {label: '#metric-leafletting', value: 100, visualLabel: '#visual-leafletting'},
            {label: '#metric-chalking', value: 110, visualLabel: '#visual-chalking'},
            {label: '#metric-door-knocking', value: 85, visualLabel: '#visual-door-knocking'},
            {label: '#metric-1-1-recruiter', value: 120, visualLabel: '#visual-1-1-recruiter'},
            {label: '#metric-street-stalls', value: 115, visualLabel: '#visual-street-stalls'},
            {label: '#metric-house-meetings', value: 95, visualLabel: '#visual-house-meetings'},
        ]
    }

    render json: report_data
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


  def nowMinusDays(numDays)
    (DateTime.now - numDays.days).strftime("%d %B")
  end

end
