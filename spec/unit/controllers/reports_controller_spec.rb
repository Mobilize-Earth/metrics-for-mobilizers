require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe "table" do
    before :each do
      seed_db
    end

    it "returns countries data" do
      get :table, params: { period: 'week' }
      json_response = JSON.parse(response.body)
      result = json_response.sample
      country = result["country"]

      active_members = Chapter.with_addresses.where(addresses: {country: country}).sum("active_members")
      chapters = Chapter.with_addresses.where(addresses: {country: country}).count
      signups = Mobilization.with_addresses.where(addresses: {country: country}).sum("new_members_sign_ons")
      trainings = Training.with_addresses.where(addresses: {country: country}).count
      pledges = Mobilization.with_addresses.where(addresses: {country: country}).sum("arrestable_pledges")
      actions = StreetSwarm.with_addresses.where(addresses: {country: country}).count +
          ArrestableAction.with_addresses.where(addresses: {country: country}).count
      subscriptions = Mobilization.with_addresses.where(addresses: {country: country}).sum("xra_donation_suscriptions")

      expect(result["members"]).to eq(active_members)
      expect(result["chapters"]).to eq(chapters)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["arrestable_pledges"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["subscriptions"]).to eq(subscriptions)
    end

    it "returns US Region data" do
      get :table, params: { country: 'US', period: 'week' }
      json_response = JSON.parse(response.body)
      result = json_response.first
      region_states =  Regions.us_regions[result['id'].to_sym][:states]

      active_members = Chapter.with_addresses.where(addresses: {state_province: region_states}).sum("active_members")
      chapters = Chapter.with_addresses.where(addresses: {state_province: region_states}).count
      signups = Mobilization.with_addresses.where(addresses: {state_province: region_states}).sum("new_members_sign_ons")
      trainings = Training.with_addresses.where(addresses: {state_province: region_states}).count
      pledges = Mobilization.with_addresses.where(addresses: {state_province: region_states}).sum("arrestable_pledges")
      actions = StreetSwarm.with_addresses.where(addresses: {state_province: region_states}).count +
          ArrestableAction.with_addresses.where(addresses: {state_province: region_states}).count
      subscriptions = Mobilization.with_addresses.where(addresses: {state_province: region_states}).sum("xra_donation_suscriptions")

      expect(result["members"]).to eq(active_members)
      expect(result["chapters"]).to eq(chapters)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["arrestable_pledges"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["subscriptions"]).to eq(subscriptions)
    end

    it "returns US State data from region" do
      get :table, params: { country: 'US', region: 'region_1', period: 'week' }
      json_response = JSON.parse(response.body)
      result = json_response.first
      state = result['state']

      active_members = Chapter.with_addresses.where(addresses: {state_province: state}).sum("active_members")
      chapters = Chapter.with_addresses.where(addresses: {state_province: state}).count
      signups = Mobilization.with_addresses.where(addresses: {state_province: state}).sum("new_members_sign_ons")
      trainings = Training.with_addresses.where(addresses: {state_province: state}).count
      pledges = Mobilization.with_addresses.where(addresses: {state_province: state}).sum("arrestable_pledges")
      actions = StreetSwarm.with_addresses.where(addresses: {state_province: state}).count +
          ArrestableAction.with_addresses.where(addresses: {state_province: state}).count
      subscriptions = Mobilization.with_addresses.where(addresses: {state_province: state}).sum("xra_donation_suscriptions")

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
      get :table, params: { country: 'AU', period: 'week' }
      json_response = JSON.parse(response.body)
      result = json_response.first

      active_members = Chapter.with_addresses.where(addresses: {country: country}).sum("active_members")
      chapters = Chapter.with_addresses.where(addresses: {country: country}).count
      signups = Mobilization.with_addresses.where(addresses: {country: country}).sum("new_members_sign_ons")
      trainings = Training.with_addresses.where(addresses: {country: country}).count
      pledges = Mobilization.with_addresses.where(addresses: {country: country}).sum("arrestable_pledges")
      actions = StreetSwarm.with_addresses.where(addresses: {country: country}).count +
          ArrestableAction.with_addresses.where(addresses: {country: country}).count
      subscriptions = Mobilization.with_addresses.where(addresses: {country: country}).sum("xra_donation_suscriptions")

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
      get :table, params: { country: 'AU', state: state, period: 'week' }
      json_response = JSON.parse(response.body)
      result = json_response.first
      chapter = Chapter.find(result['id'])

      active_members = chapter.active_members
      signups = Mobilization.where(chapter: chapter).sum("new_members_sign_ons")
      trainings = Training.where(chapter: chapter).count
      pledges = Mobilization.where(chapter: chapter).sum("arrestable_pledges")
      actions = StreetSwarm.where(chapter: chapter).count +
          ArrestableAction.where(chapter: chapter).count
      subscriptions = Mobilization.where(chapter: chapter).sum("xra_donation_suscriptions")

      expect(result["members"]).to eq(active_members)
      expect(result["chapters"]).to eq(1)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["arrestable_pledges"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["subscriptions"]).to eq(subscriptions)
    end

    it "returns chapter data" do
      get :table, params: { country: 'AU', state: 'New South Wales', chapter: 4, period: 'week' }
      json_response = JSON.parse(response.body)
      result = json_response["result"]
      chapter = Chapter.find(4)
      expect(result["members"]).to eq(chapter.active_members)
      expect(result["chapters"]).to eq(1)
      expect(result["signups"]).to eq(Mobilization.where(chapter:chapter).sum('new_members_sign_ons'))
      expect(result["trainings"]).to eq(Training.where(chapter:chapter).count)
      expect(result["arrestable_pledges"]).to eq(Mobilization.where(chapter:chapter).sum('arrestable_pledges'))
      expect(result["actions"]).to eq(StreetSwarm.where(chapter:chapter).count + ArrestableAction.where(chapter:chapter).count)
      expect(result["mobilizations"]).to eq(Mobilization.where(chapter:chapter).count)
      expect(result["subscriptions"]).to eq(Mobilization.where(chapter:chapter).sum('xra_donation_suscriptions'))
    end
  end

  describe "tiles" do
    before :each do
      seed_db
    end

    it "should return all country data" do
      get :tiles, params: { dateRange: 'week' }
      result = JSON.parse(response.body)

      active_members = Chapter.sum("active_members")
      chapters = Chapter.count
      signups = Mobilization.sum("new_members_sign_ons")
      trainings = Training.count
      pledges = Mobilization.sum("arrestable_pledges")
      actions = StreetSwarm.count + ArrestableAction.count
      subscriptions = Mobilization.sum("xra_donation_suscriptions")

      actual_date_range = (result["end_date"].to_date - result["start_date"].to_date).to_int

      expect(result["members"]).to eq(active_members)
      expect(result["chapters"]).to eq(chapters)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["pledges_arrestable"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["subscriptions"]).to eq(subscriptions)
      expect(actual_date_range).to eq(6)
    end

    it "should return US data" do
      country = 'United States'
      get :tiles, params: { country: 'US', dateRange: 'month' }
      result = JSON.parse(response.body)

      active_members = Chapter.with_addresses.where(addresses: {country: country}).sum("active_members")
      chapters = Chapter.with_addresses.where(addresses: {country: country}).count
      signups = Mobilization.with_addresses.where(addresses: {country: country}).sum("new_members_sign_ons")
      trainings = Training.with_addresses.where(addresses: {country: country}).count
      pledges = Mobilization.with_addresses.where(addresses: {country: country}).sum("arrestable_pledges")
      actions = StreetSwarm.with_addresses.where(addresses: {country: country}).count +
          ArrestableAction.with_addresses.where(addresses: {country: country}).count
      subscriptions = Mobilization.with_addresses.where(addresses: {country: country}).sum("xra_donation_suscriptions")

      actual_date_range = (result["end_date"].to_date - result["start_date"].to_date).to_int

      expect(result["members"]).to eq(active_members)
      expect(result["chapters"]).to eq(chapters)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["pledges_arrestable"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["subscriptions"]).to eq(subscriptions)
      expect(actual_date_range).to eq(29)
    end

    it "should return New York data" do
      state = 'New York'
      get :tiles, params: { country: 'US', state: 'New York', dateRange: 'week' }
      result = JSON.parse(response.body)

      actual_date_range = (result["end_date"].to_date - result["start_date"].to_date).to_int

      active_members = Chapter.with_addresses.where(addresses: {state_province: state}).sum("active_members")
      chapters = Chapter.with_addresses.where(addresses: {state_province: state}).count
      signups = Mobilization.with_addresses.where(addresses: {state_province: state}).sum("new_members_sign_ons")
      trainings = Training.with_addresses.where(addresses: {state_province: state}).count
      pledges = Mobilization.with_addresses.where(addresses: {state_province: state}).sum("arrestable_pledges")
      actions = StreetSwarm.with_addresses.where(addresses: {state_province: state}).count +
          ArrestableAction.with_addresses.where(addresses: {state_province: state}).count
      subscriptions = Mobilization.with_addresses.where(addresses: {state_province: state}).sum("xra_donation_suscriptions")

      expect(result["members"]).to eq(active_members)
      expect(result["chapters"]).to eq(chapters)
      expect(result["signups"]).to eq(signups)
      expect(result["trainings"]).to eq(trainings)
      expect(result["pledges_arrestable"]).to eq(pledges)
      expect(result["actions"]).to eq(actions)
      expect(result["subscriptions"]).to eq(subscriptions)
      expect(actual_date_range).to eq(6)
    end

    it "should return chapter data" do
      chapter_id = 4
      get :tiles, params: { country: 'US', state: 'New York', chapter: chapter_id, dateRange: 'week' }
      result = JSON.parse(response.body)
      actual_date_range = (result["end_date"].to_date - result["start_date"].to_date).to_int
      chapter = Chapter.find(chapter_id)

      expect(result["members"]).to eq(chapter.active_members)
      expect(result["chapters"]).to eq(1)
      expect(result["signups"]).to eq(Mobilization.where(chapter:chapter).sum('new_members_sign_ons'))
      expect(result["trainings"]).to eq(Training.where(chapter:chapter).count)
      expect(result["pledges_arrestable"]).to eq(Mobilization.where(chapter:chapter).sum('arrestable_pledges'))
      expect(result["actions"]).to eq(StreetSwarm.where(chapter:chapter).count + ArrestableAction.where(chapter:chapter).count)
      expect(result["mobilizations"]).to eq(Mobilization.where(chapter:chapter).count)
      expect(result["subscriptions"]).to eq(Mobilization.where(chapter:chapter).sum('xra_donation_suscriptions'))
      expect(actual_date_range).to eq(6)
    end
  end

  describe "mobilizations chart" do
    before(:each) do
      coordinator_sign_in(FactoryBot.create(:coordinator))
    end

    it "returns global weekly data by default" do
      FactoryBot.create(:mobilization, {created_at: DateTime.now, mobilization_type: 'House Meetings', participants: 7, new_members_sign_ons: 3, total_one_time_donations:0.01,arrestable_pledges: 5})
      FactoryBot.create(:mobilization, {created_at: (DateTime.now - 14.days), mobilization_type: 'House Meetings', participants: 8, new_members_sign_ons: 5, total_one_time_donations:99,arrestable_pledges: 6})

      get :mobilizations, params: { }
      json_response = JSON.parse(response.body)
      expect(json_response["labels"][0]).to eq("Week ending #{DateTime.now.strftime("%d %B")}")
      expect(json_response["data"].map { |actual| actual["label"] }.sort).to eq(Mobilization.mobilization_type_options.sort)
      expect(json_response["data"].map { |actual| actual["new"] }).to eq([[0], [0], [0], [0], [3], [0], [0], [0]])
      expect(json_response["data"].map { |actual| actual["participants"] }).to eq([[0], [0], [0], [0], [7], [0], [0], [0]])
      expect(json_response["data"].map { |actual| actual["total_one_time_donations"] }).to eq([[0], [0], [0], [0], ["0.01"], [0], [0], [0]])
      expect(json_response["data"].map { |actual| actual["arrestable_pledges"] }).to eq([[0], [0], [0], [0], [5], [0], [0], [0]])
    end

    it "returns monthly data" do
      FactoryBot.create(:mobilization, {created_at: DateTime.now, mobilization_type: 'House Meetings', participants: 7, new_members_sign_ons: 3,total_one_time_donations:0.01, arrestable_pledges: 5})
      FactoryBot.create(:mobilization, {created_at: (DateTime.now - 14.days), mobilization_type: 'House Meetings', participants: 8, new_members_sign_ons: 5,total_one_time_donations:99, arrestable_pledges: 1})

      get :mobilizations, params: { dateRange: 'month' }
      json_response = JSON.parse(response.body)
      expect(json_response["labels"][3]).to eq("Week ending #{DateTime.now.strftime("%d %B")}")
      expect(json_response["labels"][2]).to eq("Week ending #{(DateTime.now - 7.days).strftime("%d %B")}")
      expect(json_response["labels"][1]).to eq("Week ending #{(DateTime.now - 14.days).strftime("%d %B")}")
      expect(json_response["labels"][0]).to eq("Week ending #{(DateTime.now - 21.days).strftime("%d %B")}")
      expect(json_response["data"].map { |actual| actual["label"] }.sort).to eq(Mobilization.mobilization_type_options.sort)
      expect(json_response["data"].map { |actual| actual["new"] }).to eq([[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,5,0,3], [0,0,0,0], [0,0,0,0], [0,0,0,0]])
      expect(json_response["data"].map { |actual| actual["participants"] }).to eq([[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,8,0,7], [0,0,0,0], [0,0,0,0], [0,0,0,0]])
      expect(json_response["data"].map { |actual| actual["total_one_time_donations"] }).to eq([[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,"99.0",0,"0.01"], [0,0,0,0], [0,0,0,0], [0,0,0,0]])
      expect(json_response["data"].map { |actual| actual["arrestable_pledges"] }).to eq([[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,1,0,5], [0,0,0,0], [0,0,0,0], [0,0,0,0]])
    end

    it "returns quarterly data" do
      FactoryBot.create(:mobilization, {created_at: DateTime.now, mobilization_type: 'House Meetings', participants: 7, new_members_sign_ons: 3, total_one_time_donations:0.01, arrestable_pledges: 5})
      FactoryBot.create(:mobilization, {created_at: (DateTime.now - 2.months), mobilization_type: 'House Meetings', participants: 8, new_members_sign_ons: 4, total_one_time_donations:99, arrestable_pledges: 7})
      FactoryBot.create(:mobilization, {created_at: (DateTime.now - 4.months), mobilization_type: 'House Meetings', participants: 9, new_members_sign_ons: 5, total_one_time_donations:103.99, arrestable_pledges: 9})

      get :mobilizations, params: { dateRange: 'quarter' }
      json_response = JSON.parse(response.body)
      expect(json_response["labels"][2]).to eq("Month of #{DateTime.now.strftime("%B %Y")}")
      expect(json_response["labels"][1]).to eq("Month of #{(DateTime.now - 1.months).strftime("%B %Y")}")
      expect(json_response["labels"][0]).to eq("Month of #{(DateTime.now - 2.months).strftime("%B %Y")}")
      expect(json_response["data"].map { |actual| actual["label"] }.sort).to eq(Mobilization.mobilization_type_options.sort)
      expect(json_response["data"].map { |actual| actual["new"] }).to eq([[0,0,0], [0,0,0], [0,0,0], [0,0,0], [4,0,3], [0,0,0], [0,0,0], [0,0,0]])
      expect(json_response["data"].map { |actual| actual["participants"] }).to eq([[0,0,0], [0,0,0], [0,0,0], [0,0,0], [8,0,7], [0,0,0], [0,0,0], [0,0,0]])
      expect(json_response["data"].map { |actual| actual["total_one_time_donations"] }).to eq([[0,0,0], [0,0,0], [0,0,0], [0,0,0], ["99.0",0,"0.01"], [0,0,0], [0,0,0], [0,0,0]])
      expect(json_response["data"].map { |actual| actual["arrestable_pledges"] }).to eq([[0,0,0], [0,0,0], [0,0,0], [0,0,0], [7,0,5], [0,0,0], [0,0,0], [0,0,0]])
    end

    it "returns bi-annual data" do
      FactoryBot.create(:mobilization, {created_at: DateTime.now, mobilization_type: 'House Meetings', participants: 7, new_members_sign_ons: 3, total_one_time_donations:0.01, arrestable_pledges: 5})
      FactoryBot.create(:mobilization, {created_at: (DateTime.now - 2.months), mobilization_type: 'House Meetings', participants: 8, new_members_sign_ons: 4, total_one_time_donations:99, arrestable_pledges: 7})
      FactoryBot.create(:mobilization, {created_at: (DateTime.now - 4.months), mobilization_type: 'House Meetings', participants: 9, new_members_sign_ons: 5, total_one_time_donations:103.99, arrestable_pledges: 9})

      get :mobilizations, params: { dateRange: 'half-year' }
      json_response = JSON.parse(response.body)
      expect(json_response["labels"][5]).to eq("Month of #{DateTime.now.strftime("%B %Y")}")
      expect(json_response["labels"][4]).to eq("Month of #{(DateTime.now - 1.months).strftime("%B %Y")}")
      expect(json_response["labels"][3]).to eq("Month of #{(DateTime.now - 2.months).strftime("%B %Y")}")
      expect(json_response["labels"][2]).to eq("Month of #{(DateTime.now - 3.months).strftime("%B %Y")}")
      expect(json_response["labels"][1]).to eq("Month of #{(DateTime.now - 4.months).strftime("%B %Y")}")
      expect(json_response["labels"][0]).to eq("Month of #{(DateTime.now - 5.months).strftime("%B %Y")}")
      expect(json_response["data"].map { |actual| actual["label"] }.sort).to eq(Mobilization.mobilization_type_options.sort)
      expect(json_response["data"].map { |actual| actual["new"] }).to eq([[0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,5,0,4,0,3], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0]])
      expect(json_response["data"].map { |actual| actual["participants"] }).to eq([[0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,9,0,8,0,7], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0]])
      expect(json_response["data"].map { |actual| actual["total_one_time_donations"] }).to eq([[0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,"103.99",0,"99.0",0,"0.01"], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0]])
      expect(json_response["data"].map { |actual| actual["arrestable_pledges"] }).to eq([[0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,9,0,7,0,5], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0]])
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
    FactoryBot.create(:chapter, name: "Global Chapter: #{i}") do |chapter|
      FactoryBot.create :address, country: "Australia", state_province: "New South Wales", chapter: chapter
      FactoryBot.create_list :virtual_mobilization, 2, chapter: chapter, user: user
      FactoryBot.create_list :street_swarm, 2, chapter: chapter, user: user
      FactoryBot.create_list :training, 2, chapter: chapter, user: user
      FactoryBot.create_list :arrestable_action, 2, chapter: chapter, user: user
    end
  end
  coordinator_sign_in(user)
end
