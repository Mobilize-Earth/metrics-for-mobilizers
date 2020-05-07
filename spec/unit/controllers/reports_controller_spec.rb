require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe "table" do
    before :each do
      seed_db
    end

    it "returns weekly countries data" do
      get :table, params: {period: 'week'}
      json_response = JSON.parse(response.body)
      result = json_response.sample
      country = result["country"]

      active_members = Chapter.with_addresses.where(addresses: {country: country}).sum("active_members")
      chapters = Chapter.with_addresses.where(addresses: {country: country}).count
      mobilizations = Mobilization.with_addresses.where(addresses: {country: country}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      signups = Mobilization.with_addresses.where(addresses: {country: country}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
          sum("xra_newsletter_sign_ups")
      trainings = Training.with_addresses.where(addresses: {country: country}).
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      pledges = Mobilization.with_addresses.where(addresses: {country: country}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).sum("arrestable_pledges")
      actions = StreetSwarm.with_addresses.where(addresses: {country: country}).
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count +
          ArrestableAction.with_addresses.where(addresses: {country: country}).
              where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      subscriptions = Chapter.with_addresses.where(addresses: {country: country}).sum("total_subscription_amount").to_int

      expect(result["chapters"]).to eq(chapters)
      expect(result["members"]).to eq(active_members)
      expect(result["mobilizations"]).to eq(mobilizations)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["arrestable_pledges"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["subscriptions"]).to eq(subscriptions)
    end

    it "returns monthly countries data" do
      get :table, params: {period: 'month'}
      json_response = JSON.parse(response.body)
      result = json_response.sample
      country = result["country"]

      active_members = Chapter.with_addresses.where(addresses: {country: country}).sum("active_members")
      chapters = Chapter.with_addresses.where(addresses: {country: country}).count
      signups = Mobilization.with_addresses.where(addresses: {country: country}).sum("xra_newsletter_sign_ups")
      trainings = Training.with_addresses.where(addresses: {country: country}).count
      pledges = Mobilization.with_addresses.where(addresses: {country: country}).sum("arrestable_pledges")
      actions = StreetSwarm.with_addresses.where(addresses: {country: country}).count +
          ArrestableAction.with_addresses.where(addresses: {country: country}).count
      subscriptions = Chapter.with_addresses.where(addresses: {country: country}).sum("total_subscription_amount").to_int


      expect(result["members"]).to eq(active_members)
      expect(result["chapters"]).to eq(chapters)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["arrestable_pledges"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["subscriptions"]).to eq(subscriptions)
    end

    it "returns US Region data" do
      get :table, params: {country: 'US', period: 'week'}
      json_response = JSON.parse(response.body)
      result = json_response.first
      region_states = Regions.us_regions[result['id'].to_sym][:states]

      active_members = Chapter.with_addresses.where(addresses: {state_province: region_states}).sum("active_members")
      chapters = Chapter.with_addresses.where(addresses: {state_province: region_states}).count
      signups = Mobilization.with_addresses.where(addresses: {state_province: region_states}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
          sum("xra_newsletter_sign_ups")
      trainings = Training.with_addresses.where(addresses: {state_province: region_states}).
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
          count
      pledges = Mobilization.with_addresses.where(addresses: {state_province: region_states}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
          sum("arrestable_pledges")
      actions = StreetSwarm.with_addresses.where(addresses: {state_province: region_states}).
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count +
          ArrestableAction.with_addresses.where(addresses: {state_province: region_states}).
              where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      subscriptions = Chapter.with_addresses.where(addresses: {state_province: region_states}).sum("total_subscription_amount").to_int

      expect(result["members"]).to eq(active_members)
      expect(result["chapters"]).to eq(chapters)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["arrestable_pledges"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["subscriptions"]).to eq(subscriptions)
    end

    it "returns US State data from region" do
      get :table, params: {country: 'US', region: 'region_1', period: 'week'}
      json_response = JSON.parse(response.body)
      result = json_response.first
      state = result['state']

      active_members = Chapter.with_addresses.where(addresses: {state_province: state}).sum("active_members")
      chapters = Chapter.with_addresses.where(addresses: {state_province: state}).count
      signups = Mobilization.with_addresses.where(addresses: {state_province: state}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
          sum("xra_newsletter_sign_ups")
      trainings = Training.with_addresses.where(addresses: {state_province: state}).
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      pledges = Mobilization.with_addresses.where(addresses: {state_province: state}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
          sum("arrestable_pledges")
      actions = StreetSwarm.with_addresses.where(addresses: {state_province: state}).
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count +
          ArrestableAction.with_addresses.where(addresses: {state_province: state}).
              where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      subscriptions = Chapter.with_addresses.where(addresses: {state_province: state}).sum("total_subscription_amount").to_int

      expect(result["members"]).to eq(active_members)
      expect(result["chapters"]).to eq(chapters)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["arrestable_pledges"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["subscriptions"]).to eq(subscriptions)
    end

    it "returns Non US Country data" do
      country = 'Australia'
      get :table, params: {country: 'AU', period: 'week'}
      json_response = JSON.parse(response.body)
      result = json_response.first

      active_members = Chapter.with_addresses.where(addresses: {country: country}).sum("active_members")
      chapters = Chapter.with_addresses.where(addresses: {country: country}).count
      signups = Mobilization.with_addresses.where(addresses: {country: country}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
          sum("xra_newsletter_sign_ups")
      trainings = Training.with_addresses.where(addresses: {country: country}).
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      pledges = Mobilization.with_addresses.where(addresses: {country: country}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).sum("arrestable_pledges")
      actions = StreetSwarm.with_addresses.where(addresses: {country: country}).
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count +
          ArrestableAction.with_addresses.where(addresses: {country: country}).
              where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      subscriptions = Chapter.with_addresses.where(addresses: {country: country}).sum("total_subscription_amount").to_int

      expect(result["members"]).to eq(active_members)
      expect(result["chapters"]).to eq(chapters)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["arrestable_pledges"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["subscriptions"]).to eq(subscriptions)
    end

    it "returns non US state data" do
      state = 'New South Wales'
      get :table, params: {country: 'AU', state: state, period: 'week'}
      json_response = JSON.parse(response.body)
      result = json_response.first

      chapter = Chapter.find(result['id'])


      active_members = chapter.active_members
      signups = Mobilization.where(chapter: chapter).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
          sum("xra_newsletter_sign_ups")
      trainings = Training.where(chapter: chapter).
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      pledges = Mobilization.where(chapter: chapter).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
          sum("arrestable_pledges")
      actions = StreetSwarm.where(chapter: chapter).
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count +
          ArrestableAction.where(chapter: chapter).
              where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      subscriptions = chapter.total_subscription_amount.to_int

      expect(result["members"]).to eq(active_members)
      expect(result["chapters"]).to eq(1)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["arrestable_pledges"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["subscriptions"]).to eq(subscriptions)
    end

    it "returns chapter data" do
      get :table, params: {country: 'AU', state: 'New South Wales', chapter: 1, period: 'week'}
      json_response = JSON.parse(response.body)
      result = json_response["result"]
      chapter = Chapter.find(1)

      signups = Mobilization.where(chapter: chapter).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
          sum('xra_newsletter_sign_ups')
      trainings = Training.where(chapter: chapter).
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      pledges = Mobilization.where(chapter: chapter).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
          sum("arrestable_pledges")
      actions = StreetSwarm.where(chapter: chapter).
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count +
          ArrestableAction.where(chapter: chapter).
              where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      subscriptions = chapter.total_subscription_amount.to_int


      expect(result["members"]).to eq(chapter.active_members)
      expect(result["chapters"]).to eq(1)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["arrestable_pledges"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["mobilizations"]).to eq(Mobilization.where(chapter: chapter).count)
      expect(result["subscriptions"]).to eq(subscriptions)
    end
  end

  describe "tiles" do
    before :each do
      seed_db
    end

    it "should return all country data" do
      get :tiles, params: {dateRange: 'week'}
      result = JSON.parse(response.body)

      active_members = Chapter.sum("active_members")

      chapters_in_this_period = Chapter.
          where('chapters.created_at >= ?', (DateTime.now - 6.days).beginning_of_day)
      members_in_this_period = chapters_in_this_period.sum("active_members") +
          Mobilization.where('mobilizations.created_at >= ?', (DateTime.now - 6.days).beginning_of_day).
              where('mobilizations.chapter_id NOT IN (?)', chapters_in_this_period.map(&:id)).
              sum("new_members_sign_ons")

      pledges = Chapter.sum("total_arrestable_pledges")
      pledges_in_this_period = chapters_in_this_period.sum("total_arrestable_pledges") +
          Mobilization.
              where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
              where('mobilizations.chapter_id NOT IN (?)', chapters_in_this_period.map(&:id)).
              sum("arrestable_pledges")

      subscriptions = Chapter.sum("total_subscription_amount").to_int

      # TODO - We are currently using mobilizations.total_one_time_donations to calculate new subscriptions in a period.
      # We should update this DB column name to be total_donation_subscriptions instead. This applies to the tests below too.

      subscriptions_in_this_period = chapters_in_this_period.sum("total_subscription_amount").to_int +
          Mobilization.where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
              where('mobilizations.chapter_id NOT IN (?)', chapters_in_this_period.map(&:id)).
              sum("total_one_time_donations").to_int

      chapters = Chapter.count

      mobilizations = Mobilization.
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      previous_period_mobilizations = Mobilization.
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day).count
      signups = Mobilization.
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day)
                    .sum("xra_newsletter_sign_ups")
      previous_period_signups = Mobilization.
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day)
                                    .sum("xra_newsletter_sign_ups")
      trainings = Training.
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      previous_period_trainings = Training.
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day).count

      actions = StreetSwarm.
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day)
                    .count + ArrestableAction.
          where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      previous_period_actions = StreetSwarm.
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day)
                                    .count + ArrestableAction.
          where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day).count

      actual_date_range = (result["end_date"].to_date - result["start_date"].to_date).to_int

      expect(result["members"]).to eq(active_members)
      expect(result["members_growth"]).to eq(members_in_this_period)
      expect(result["chapters"]).to eq(chapters)
      expect(result["chapters_growth"]).to eq(chapters_in_this_period.count)
      expect(result["mobilizations"]).to eq(mobilizations)
      expect(result["mobilizations_growth"]).to eq(mobilizations - previous_period_mobilizations)
      expect(result["signups"]).to eq(signups)
      expect(result["signups_growth"]).to eq(signups - previous_period_signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["trainings_growth"]).to eq(trainings - previous_period_trainings)
      expect(result["pledges_arrestable"]).to eq(pledges)
      expect(result["pledges_arrestable_growth"]).to eq(pledges_in_this_period)
      expect(result["actions"]).to eq(actions)
      expect(result["actions_growth"]).to eq(actions - previous_period_actions)
      expect(result["subscriptions"]).to eq(subscriptions)
      expect(result["subscriptions_growth"]).to eq(subscriptions_in_this_period)
      expect(actual_date_range).to eq(6)
    end

    it "should return US data" do
      country = 'United States'
      get :tiles, params: {country: 'US', dateRange: 'week'}
      result = JSON.parse(response.body)

      chapters = Chapter.with_addresses.where(addresses: {country: country}).count
      chapters_in_this_period = Chapter.with_addresses.
          where(addresses: {country: country}).
          where('chapters.created_at >= ?', (DateTime.now - 6.days).beginning_of_day)

      active_members = Chapter.with_addresses.where(addresses: {country: country}).sum("active_members")
      members_in_this_period = chapters_in_this_period.sum("active_members") +
          Mobilization.with_addresses.
              where(addresses: {country: country}).
              where('mobilizations.created_at >= ?', (DateTime.now - 6.days).beginning_of_day).
              where('mobilizations.chapter_id NOT IN (?)', chapters_in_this_period.map(&:id)).
              sum("new_members_sign_ons")

      subscriptions = Chapter.with_addresses.
          where(addresses: {country: country}).sum("total_subscription_amount").to_int

      subscriptions_in_this_period = chapters_in_this_period.sum("total_subscription_amount").to_int +
          Mobilization.with_addresses.where(addresses: {country: country}).
              where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
              where('mobilizations.chapter_id NOT IN (?)', chapters_in_this_period.map(&:id)).
              sum("total_one_time_donations").to_int

      pledges = Chapter.with_addresses.where(addresses: {country: country}).sum("total_arrestable_pledges")
      pledges_in_this_period = chapters_in_this_period.sum("total_arrestable_pledges") +
          Mobilization.with_addresses.where(addresses: {country: country}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
          where('mobilizations.chapter_id NOT IN (?)', chapters_in_this_period.map(&:id)).
                                    sum("arrestable_pledges")

      mobilizations = Mobilization.with_addresses.
          where(addresses: {country: country}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      previous_period_mobilizations = Mobilization.
          with_addresses.where(addresses: {country: country}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day).count
      signups = Mobilization.
          with_addresses.where(addresses: {country: country}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day)
                    .sum("xra_newsletter_sign_ups")
      previous_period_signups = Mobilization.
          with_addresses.where(addresses: {country: country}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day)
                                    .sum("xra_newsletter_sign_ups")
      trainings = Training.
          with_addresses.where(addresses: {country: country}).
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      previous_period_trainings = Training.
          with_addresses.where(addresses: {country: country}).
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day).count

      actions = StreetSwarm.
          with_addresses.where(addresses: {country: country}).
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day)
                    .count + ArrestableAction.
          with_addresses.where(addresses: {country: country}).
          where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      previous_period_actions = StreetSwarm.
          with_addresses.where(addresses: {country: country}).
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day)
                                    .count + ArrestableAction.
          with_addresses.where(addresses: {country: country}).
          where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day).count

      actual_date_range = (result["end_date"].to_date - result["start_date"].to_date).to_int

      expect(result["members"]).to eq(active_members)
      expect(result["members_growth"]).to eq(members_in_this_period)
      expect(result["chapters"]).to eq(chapters)
      expect(result["chapters_growth"]).to eq(chapters_in_this_period.count)
      expect(result["mobilizations"]).to eq(mobilizations)
      expect(result["mobilizations_growth"]).to eq(mobilizations - previous_period_mobilizations)
      expect(result["signups"]).to eq(signups)
      expect(result["signups_growth"]).to eq(signups - previous_period_signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["trainings_growth"]).to eq(trainings - previous_period_trainings)
      expect(result["pledges_arrestable"]).to eq(pledges)
      expect(result["pledges_arrestable_growth"]).to eq(pledges_in_this_period)
      expect(result["actions"]).to eq(actions)
      expect(result["actions_growth"]).to eq(actions - previous_period_actions)
      expect(result["subscriptions"]).to eq(subscriptions)
      expect(result["subscriptions_growth"]).to eq(subscriptions_in_this_period)
      expect(actual_date_range).to eq(6)
    end

    it "should return New York data" do
      state = 'New York'
      get :tiles, params: {country: 'US', state: 'New York', dateRange: 'week'}
      result = JSON.parse(response.body)

      actual_date_range = (result["end_date"].to_date - result["start_date"].to_date).to_int

      chapters = Chapter.with_addresses.where(addresses: {state_province: state}).count
      chapters_in_this_period = Chapter.with_addresses.
          where(addresses: {state_province: state}).
          where('chapters.created_at >= ?', (DateTime.now - 6.days).beginning_of_day)
      active_members = Chapter.with_addresses.
          where(addresses: {state_province: state}).
          sum("active_members")
      members_in_this_period = chapters_in_this_period.sum("active_members") +
          Mobilization.with_addresses.
              where(addresses: {state_province: state}).
              where('mobilizations.created_at >= ?', (DateTime.now - 6.days).beginning_of_day).
              where('mobilizations.chapter_id NOT IN (?)', chapters_in_this_period.map(&:id)).
              sum("new_members_sign_ons")

      subscriptions = Chapter.with_addresses.
          where(addresses: {state_province: state}).
          sum("total_subscription_amount").to_int

      subscriptions_in_this_period = chapters_in_this_period.sum("total_subscription_amount").to_int +
          Mobilization.with_addresses.where(addresses: {state_province: state}).
              where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
              where('mobilizations.chapter_id NOT IN (?)', chapters_in_this_period.map(&:id)).
              sum("total_one_time_donations").to_int

      pledges = Chapter.with_addresses.where(addresses: {state_province: state}).sum("total_arrestable_pledges")
      pledges_in_this_period = chapters_in_this_period.sum("total_arrestable_pledges") +
          Mobilization.with_addresses.where(addresses: {state_province: state}).
              where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).
              where('mobilizations.chapter_id NOT IN (?)', chapters_in_this_period.map(&:id)).
              sum("arrestable_pledges")

      mobilizations = Mobilization.with_addresses.
          where(addresses: {state_province: state}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      previous_period_mobilizations = Mobilization.with_addresses.
          where(addresses: {state_province: state}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day).count
      signups = Mobilization.with_addresses.
          where(addresses: {state_province: state}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day)
                    .sum("xra_newsletter_sign_ups")
      previous_period_signups = Mobilization.with_addresses.
          where(addresses: {state_province: state}).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day)
                                    .sum("xra_newsletter_sign_ups")
      trainings = Training.with_addresses.
          where(addresses: {state_province: state}).
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      previous_period_trainings = Training.with_addresses.
          where(addresses: {state_province: state}).
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day).count

      actions = StreetSwarm.with_addresses.
          where(addresses: {state_province: state}).
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day)
                    .count + ArrestableAction.with_addresses.
          where(addresses: {state_province: state}).
          where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      previous_period_actions = StreetSwarm.with_addresses.
          where(addresses: {state_province: state}).
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day)
                                    .count + ArrestableAction.with_addresses.
          where(addresses: {state_province: state}).
          where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day).count

      expect(result["members"]).to eq(active_members)
      expect(result["members_growth"]).to eq(members_in_this_period)
      expect(result["chapters"]).to eq(chapters)
      expect(result["chapters_growth"]).to eq(chapters_in_this_period.count)
      expect(result["mobilizations"]).to eq(mobilizations)
      expect(result["mobilizations_growth"]).to eq(mobilizations - previous_period_mobilizations)
      expect(result["signups"]).to eq(signups)
      expect(result["signups_growth"]).to eq(signups - previous_period_signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["trainings_growth"]).to eq(trainings - previous_period_trainings)
      expect(result["pledges_arrestable"]).to eq(pledges)
      expect(result["pledges_arrestable_growth"]).to eq(pledges_in_this_period)
      expect(result["actions"]).to eq(actions)
      expect(result["actions_growth"]).to eq(actions - previous_period_actions)
      expect(result["subscriptions"]).to eq(subscriptions)
      expect(result["subscriptions_growth"]).to eq(subscriptions_in_this_period)
      expect(actual_date_range).to eq(6)
    end

    it "should return chapter data" do
      chapter_id = 1
      get :tiles, params: {country: 'US', state: 'New York', chapter: chapter_id, dateRange: 'week'}
      result = JSON.parse(response.body)
      actual_date_range = (result["end_date"].to_date - result["start_date"].to_date).to_int

      chapter = Chapter.find(chapter_id)

      mobilizations = Mobilization.where(chapter: chapter).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      previous_period_mobilizations = Mobilization.where(chapter: chapter).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day).count
      signups = Mobilization.where(chapter: chapter).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day)
                    .sum("xra_newsletter_sign_ups")
      previous_period_signups = Mobilization.where(chapter: chapter).
          where('mobilizations.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day)
                                    .sum("xra_newsletter_sign_ups")
      trainings = Training.where(chapter: chapter).
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      previous_period_trainings = Training.where(chapter: chapter).
          where('trainings.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day).count
      actions = StreetSwarm.where(chapter: chapter).
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day)
                    .count + ArrestableAction.where(chapter: chapter).
          where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 6.days).beginning_of_day, DateTime.now.end_of_day).count
      previous_period_actions = StreetSwarm.where(chapter: chapter).
          where('street_swarms.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day)
                                    .count + ArrestableAction.where(chapter: chapter).
          where('arrestable_actions.created_at BETWEEN ? AND ?', (DateTime.now - 13.days).beginning_of_day, (DateTime.now - 6.days).beginning_of_day).count

      expect(result["members"]).to eq(chapter.active_members)
      expect(result["members_growth"]).to eq(chapter.active_members)
      expect(result["chapters"]).to eq(1)
      expect(result["mobilizations"]).to eq(mobilizations)
      expect(result["mobilizations_growth"]).to eq(mobilizations - previous_period_mobilizations)
      expect(result["signups"]).to eq(signups)
      expect(result["signups_growth"]).to eq(signups - previous_period_signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["trainings_growth"]).to eq(trainings - previous_period_trainings)
      expect(result["pledges_arrestable"]).to eq(chapter.total_arrestable_pledges)
      expect(result["pledges_arrestable_growth"]).to eq(chapter.total_arrestable_pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["actions_growth"]).to eq(actions - previous_period_actions)
      expect(result["subscriptions"]).to eq(chapter.total_subscription_amount.to_int)
      expect(result["subscriptions_growth"]).to eq(chapter.total_subscription_amount.to_int)
      expect(actual_date_range).to eq(6)

      old_chapter_id = 4
      get :tiles, params: {country: 'US', state: 'New York', chapter: old_chapter_id, dateRange: 'week'}
      new_result = JSON.parse(response.body)
      old_chapter = Chapter.find(old_chapter_id)
      new_members_in_this_period = Mobilization.with_addresses.
          where(chapter: old_chapter_id).
          where('mobilizations.created_at >= ?', (DateTime.now - 6.days).beginning_of_day).
          sum("new_members_sign_ons")

      new_subscriptions_in_this_period = Mobilization.with_addresses.
          where(chapter: old_chapter).
          where('mobilizations.created_at >= ?', (DateTime.now - 6.days).beginning_of_day).
          sum("total_one_time_donations").to_int

      expect(new_result["members_growth"]).to eq(new_members_in_this_period)
      expect(new_result["subscriptions_growth"]).to eq(new_subscriptions_in_this_period)
    end
  end

  describe "mobilizations chart" do
    before(:each) do
      coordinator_sign_in(FactoryBot.create(:coordinator))
    end

    it "returns global weekly data by default" do
      FactoryBot.create(:mobilization, {created_at: DateTime.now, mobilization_type: 'House Meetings', participants: 7, new_members_sign_ons: 3, total_one_time_donations: 0.01, arrestable_pledges: 5})
      FactoryBot.create(:mobilization, {created_at: (DateTime.now - 14.days), mobilization_type: 'House Meetings', participants: 8, new_members_sign_ons: 5, total_one_time_donations: 99, arrestable_pledges: 6})

      get :mobilizations, params: {}
      json_response = JSON.parse(response.body)
      expect(json_response["labels"][0]).to eq("Week ending #{DateTime.now.strftime("%d %B")}")
      expect(json_response["data"].map { |actual| actual["label"] }.sort).to eq(Mobilization.mobilization_type_options.sort)
      expect(json_response["data"].map { |actual| actual["new"] }).to eq([[0], [0], [0], [0], [3], [0], [0], [0]])
      expect(json_response["data"].map { |actual| actual["participants"] }).to eq([[0], [0], [0], [0], [7], [0], [0], [0]])
      expect(json_response["data"].map { |actual| actual["total_one_time_donations"] }).to eq([[0], [0], [0], [0], ["0.01"], [0], [0], [0]])
      expect(json_response["data"].map { |actual| actual["arrestable_pledges"] }).to eq([[0], [0], [0], [0], [5], [0], [0], [0]])
    end

    it "returns monthly data" do
      FactoryBot.create(:mobilization, {created_at: DateTime.now, mobilization_type: 'House Meetings', participants: 7, new_members_sign_ons: 3, total_one_time_donations: 0.01, arrestable_pledges: 5})
      FactoryBot.create(:mobilization, {created_at: (DateTime.now - 14.days), mobilization_type: 'House Meetings', participants: 8, new_members_sign_ons: 5, total_one_time_donations: 99, arrestable_pledges: 1})

      get :mobilizations, params: {dateRange: 'month'}
      json_response = JSON.parse(response.body)
      expect(json_response["labels"][3]).to eq("Week ending #{DateTime.now.strftime("%d %B")}")
      expect(json_response["labels"][2]).to eq("Week ending #{(DateTime.now - 7.days).strftime("%d %B")}")
      expect(json_response["labels"][1]).to eq("Week ending #{(DateTime.now - 14.days).strftime("%d %B")}")
      expect(json_response["labels"][0]).to eq("Week ending #{(DateTime.now - 21.days).strftime("%d %B")}")
      expect(json_response["data"].map { |actual| actual["label"] }.sort).to eq(Mobilization.mobilization_type_options.sort)
      expect(json_response["data"].map { |actual| actual["new"] }).to eq([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 5, 0, 3], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])
      expect(json_response["data"].map { |actual| actual["participants"] }).to eq([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 8, 0, 7], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])
      expect(json_response["data"].map { |actual| actual["total_one_time_donations"] }).to eq([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, "99.0", 0, "0.01"], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])
      expect(json_response["data"].map { |actual| actual["arrestable_pledges"] }).to eq([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 1, 0, 5], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]])
    end

    it "returns quarterly data" do
      FactoryBot.create(:mobilization, {created_at: DateTime.now, mobilization_type: 'House Meetings', participants: 7, new_members_sign_ons: 3, total_one_time_donations: 0.01, arrestable_pledges: 5})
      FactoryBot.create(:mobilization, {created_at: (DateTime.now - 2.months), mobilization_type: 'House Meetings', participants: 8, new_members_sign_ons: 4, total_one_time_donations: 99, arrestable_pledges: 7})
      FactoryBot.create(:mobilization, {created_at: (DateTime.now - 4.months), mobilization_type: 'House Meetings', participants: 9, new_members_sign_ons: 5, total_one_time_donations: 103.99, arrestable_pledges: 9})

      get :mobilizations, params: {dateRange: 'quarter'}
      json_response = JSON.parse(response.body)
      expect(json_response["labels"][2]).to eq("Month of #{DateTime.now.strftime("%B %Y")}")
      expect(json_response["labels"][1]).to eq("Month of #{(DateTime.now - 1.months).strftime("%B %Y")}")
      expect(json_response["labels"][0]).to eq("Month of #{(DateTime.now - 2.months).strftime("%B %Y")}")
      expect(json_response["data"].map { |actual| actual["label"] }.sort).to eq(Mobilization.mobilization_type_options.sort)
      expect(json_response["data"].map { |actual| actual["new"] }).to eq([[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [4, 0, 3], [0, 0, 0], [0, 0, 0], [0, 0, 0]])
      expect(json_response["data"].map { |actual| actual["participants"] }).to eq([[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [8, 0, 7], [0, 0, 0], [0, 0, 0], [0, 0, 0]])
      expect(json_response["data"].map { |actual| actual["total_one_time_donations"] }).to eq([[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], ["99.0", 0, "0.01"], [0, 0, 0], [0, 0, 0], [0, 0, 0]])
      expect(json_response["data"].map { |actual| actual["arrestable_pledges"] }).to eq([[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [7, 0, 5], [0, 0, 0], [0, 0, 0], [0, 0, 0]])
    end

    it "returns bi-annual data" do
      FactoryBot.create(:mobilization, {created_at: DateTime.now, mobilization_type: 'House Meetings', participants: 7, new_members_sign_ons: 3, total_one_time_donations: 0.01, arrestable_pledges: 5})
      FactoryBot.create(:mobilization, {created_at: (DateTime.now - 2.months), mobilization_type: 'House Meetings', participants: 8, new_members_sign_ons: 4, total_one_time_donations: 99, arrestable_pledges: 7})
      FactoryBot.create(:mobilization, {created_at: (DateTime.now - 4.months), mobilization_type: 'House Meetings', participants: 9, new_members_sign_ons: 5, total_one_time_donations: 103.99, arrestable_pledges: 9})

      get :mobilizations, params: {dateRange: 'half-year'}
      json_response = JSON.parse(response.body)
      expect(json_response["labels"][5]).to eq("Month of #{DateTime.now.strftime("%B %Y")}")
      expect(json_response["labels"][4]).to eq("Month of #{(DateTime.now - 1.months).strftime("%B %Y")}")
      expect(json_response["labels"][3]).to eq("Month of #{(DateTime.now - 2.months).strftime("%B %Y")}")
      expect(json_response["labels"][2]).to eq("Month of #{(DateTime.now - 3.months).strftime("%B %Y")}")
      expect(json_response["labels"][1]).to eq("Month of #{(DateTime.now - 4.months).strftime("%B %Y")}")
      expect(json_response["labels"][0]).to eq("Month of #{(DateTime.now - 5.months).strftime("%B %Y")}")
      expect(json_response["data"].map { |actual| actual["label"] }.sort).to eq(Mobilization.mobilization_type_options.sort)
      expect(json_response["data"].map { |actual| actual["new"] }).to eq([[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 5, 0, 4, 0, 3], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]])
      expect(json_response["data"].map { |actual| actual["participants"] }).to eq([[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 9, 0, 8, 0, 7], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]])
      expect(json_response["data"].map { |actual| actual["total_one_time_donations"] }).to eq([[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, "103.99", 0, "99.0", 0, "0.01"], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]])
      expect(json_response["data"].map { |actual| actual["arrestable_pledges"] }).to eq([[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 9, 0, 7, 0, 5], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]])
    end

    it 'should return Mexico weekly data only when query has country equals to MX' do
      # setup
      FactoryBot.create(:chapter, name: 'My chapter in US') do |chapter|
        FactoryBot.create(:us_address, chapter: chapter)
        FactoryBot.create(:mobilization, chapter: chapter,
                          mobilization_type: '1:1 Recruiting / Other',
                          participants: 101,
                          total_one_time_donations: 101.00,
                          arrestable_pledges: 111)
      end

      FactoryBot.create(:chapter, name: 'My chapter in MX') do |chapter|
        FactoryBot.create(:address, country: 'Mexico', chapter: chapter)
        FactoryBot.create(:mobilization, chapter: chapter,
                          mobilization_type: '1:1 Recruiting / Other',
                          participants: 102,
                          total_one_time_donations: 102.00,
                          arrestable_pledges: 112)
      end

      # run
      get :mobilizations, params: {country: 'MX'}

      # assert
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0]["participants"][0]).to eq 102
      expect(json_response['data'][0]["total_one_time_donations"][0]).to eq "102.0"
      expect(json_response['data'][0]["arrestable_pledges"][0]).to eq 112
    end

    it 'should return US Region 3 weekly data only when query has country equals to US and region region_3' do
      # setup
      FactoryBot.create(:chapter, name: 'My chapter in US region 3') do |chapter|
        FactoryBot.create(:us_address, state_province: 'Mississippi', chapter: chapter)
        FactoryBot.create(:mobilization, chapter: chapter,
                          mobilization_type: '1:1 Recruiting / Other',
                          participants: 105,
                          total_one_time_donations: 105.00,
                          arrestable_pledges: 115)
      end

      FactoryBot.create(:chapter, name: 'My chapter in US region 2') do |chapter|
        FactoryBot.create(:us_address, state_province: 'Pennsylvania', chapter: chapter)
        FactoryBot.create(:mobilization, chapter: chapter,
                          mobilization_type: '1:1 Recruiting / Other',
                          participants: 101,
                          total_one_time_donations: 101.00,
                          arrestable_pledges: 111)
      end

      # run
      get :mobilizations, params: {country: 'US', region: 'region_3'}

      # assert
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0]["participants"][0]).to eq 105
      expect(json_response['data'][0]["total_one_time_donations"][0]).to eq "105.0"
      expect(json_response['data'][0]["arrestable_pledges"][0]).to eq 115
    end

    it 'should return state of sonora weekly data only when query has country equals to MX and state sonora' do
      # setup
      FactoryBot.create(:chapter, name: 'My chapter in Sonora, MX') do |chapter|
        FactoryBot.create(:address, country: 'Mexico', state_province: 'Sonora', chapter: chapter)
        FactoryBot.create(:mobilization, chapter: chapter,
                          mobilization_type: '1:1 Recruiting / Other',
                          participants: 77,
                          total_one_time_donations: 77.77,
                          arrestable_pledges: 77)
      end

      FactoryBot.create(:chapter, name: 'My chapter in Nuevo leon, MX') do |chapter|
        FactoryBot.create(:address, country: 'Mexico', state_province: 'Nuevo León', chapter: chapter)
        FactoryBot.create(:mobilization, chapter: chapter,
                          mobilization_type: '1:1 Recruiting / Other',
                          participants: 87,
                          total_one_time_donations: 87.77,
                          arrestable_pledges: 87)
      end

      # run
      get :mobilizations, params: { country: 'MX', state: 'Sonora' }

      # assert
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0]["participants"][0]).to eq 77
      expect(json_response['data'][0]["total_one_time_donations"][0]).to eq "77.77"
      expect(json_response['data'][0]["arrestable_pledges"][0]).to eq 77
    end

    it 'should return Chapter Mozart weekly data only when query has its chapter id' do
      # setup
      mozart_chapter_id = nil
      FactoryBot.create(:chapter, name: 'Chapter Mozart') do |chapter|
        mozart_chapter_id = chapter[:id]
        FactoryBot.create(:address, country: 'Mexico', state_province: 'Sonora', chapter: chapter)
        FactoryBot.create(:mobilization, chapter: chapter,
                          mobilization_type: '1:1 Recruiting / Other',
                          participants: 77,
                          total_one_time_donations: 77.77,
                          arrestable_pledges: 77)
      end

      FactoryBot.create(:chapter, name: 'Chapter Liszt') do |chapter|
        FactoryBot.create(:address, country: 'Mexico', state_province: 'Sonora', chapter: chapter)
        FactoryBot.create(:mobilization, chapter: chapter,
                          mobilization_type: '1:1 Recruiting / Other',
                          participants: 87,
                          total_one_time_donations: 87.77,
                          arrestable_pledges: 87)
      end

      # run
      get :mobilizations, params: { country: 'MX', state: 'Sonora', chapter: mozart_chapter_id }

      # assert
      json_response = JSON.parse(response.body)
      expect(json_response['data'][0]["participants"][0]).to eq 77
      expect(json_response['data'][0]["total_one_time_donations"][0]).to eq "77.77"
      expect(json_response['data'][0]["arrestable_pledges"][0]).to eq 77
    end

  end

  def coordinator_sign_in(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end
end

def seed_db
  user = FactoryBot.create(:user, {role: 'External'})
  3.times do |i|
    FactoryBot.create(:chapter, name: "US Chapter: #{i}") do |chapter|
      FactoryBot.create :us_address, state_province: "New York", chapter: chapter
      FactoryBot.create_list :virtual_mobilization, 2, chapter: chapter, user: user
      FactoryBot.create_list :street_swarm, 2, chapter: chapter, user: user
      FactoryBot.create_list :training, 2, chapter: chapter, user: user
      FactoryBot.create_list :arrestable_action, 2, chapter: chapter, user: user
    end
  end

  3.times do |i|
    FactoryBot.create(:chapter, name: "Old US Chapter: #{i}", created_at: (DateTime.now - 32.days).beginning_of_day) do |chapter|
      FactoryBot.create :us_address, state_province: "New York", chapter: chapter
      FactoryBot.create_list :virtual_mobilization, 4, chapter: chapter, user: user, created_at: (DateTime.now - 7.days).beginning_of_day
      FactoryBot.create_list :street_swarm, 1, chapter: chapter, user: user, created_at: (DateTime.now - 7.days).beginning_of_day
      FactoryBot.create_list :training, 1, chapter: chapter, user: user, created_at: (DateTime.now - 7.days).beginning_of_day
      FactoryBot.create_list :arrestable_action, 1, chapter: chapter, user: user, created_at: (DateTime.now - 7.days).beginning_of_day
    end
  end

  3.times do |i|
    FactoryBot.create(:chapter, name: "Global Chapter: #{i}") do |chapter|
      FactoryBot.create :address, country: "Australia", state_province: "New South Wales", chapter: chapter
      FactoryBot.create_list :virtual_mobilization, 2, chapter: chapter, user: user
      FactoryBot.create_list :street_swarm, 2, chapter: chapter, user: user
      FactoryBot.create_list :training, 2, chapter: chapter, user: user
      FactoryBot.create_list :arrestable_action, 2, chapter: chapter, user: user
    end
  end

  3.times do |i|
    FactoryBot.create(:chapter, name: "Old Global Chapter: #{i}", created_at: (DateTime.now - 32.days).beginning_of_day) do |chapter|
      FactoryBot.create :address, country: "Australia", state_province: "New South Wales", chapter: chapter
      FactoryBot.create_list :virtual_mobilization, 2, chapter: chapter, user: user, created_at: (DateTime.now - 7.days).beginning_of_day
      FactoryBot.create_list :street_swarm, 2, chapter: chapter, user: user, created_at: (DateTime.now - 7.days).beginning_of_day
      FactoryBot.create_list :training, 2, chapter: chapter, user: user, created_at: (DateTime.now - 7.days).beginning_of_day
      FactoryBot.create_list :arrestable_action, 2, chapter: chapter, user: user, created_at: (DateTime.now - 7.days).beginning_of_day
    end
  end
  coordinator_sign_in(user)
end
