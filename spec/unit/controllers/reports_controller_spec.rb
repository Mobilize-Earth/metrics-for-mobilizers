require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe "table" do
    it "returns countries data" do
      coordinator_sign_in
      get :table
      json_response = JSON.parse(response.body)
      expect(json_response.length).to equal(1)
    end

    it "returns US Region data" do
      coordinator_sign_in
      get :table, params: { country: 'US' }
      json_response = JSON.parse(response.body)
      expect(json_response.length).to equal(Regions.us_regions.length)
    end

    it "returns US State data" do
      coordinator_sign_in
      get :table, params: { country: 'US', region: 'region_1' }
      json_response = JSON.parse(response.body)
      expect(json_response.length).to equal(0)
    end
  end

  describe "mobilizations chart" do
    before(:each) do
      create_mobilizations
      coordinator_sign_in
    end

    it "returns global weekly data by default" do
      get :mobilizations, params: { }
      json_response = JSON.parse(response.body)
      expect(json_response["labels"][0]).to eq("Week ending #{DateTime.now.strftime("%d %B")}")
      expect(json_response["data"].map { |actual| actual["label"] }.sort).to eq(Mobilization.mobilization_type_options.sort)
      expect(json_response["data"].map { |actual| actual["new"] }).to eq([[0], [0], [0], [0], [3], [0], [0], [0]])
      expect(json_response["data"].map { |actual| actual["participants"] }).to eq([[0], [0], [0], [0], [7], [0], [0], [0]])
    end

    it "returns monthly data" do
      get :mobilizations, params: { dateRange: 'month' }
      json_response = JSON.parse(response.body)
      expect(json_response["labels"][3]).to eq("Week ending #{DateTime.now.strftime("%d %B")}")
      expect(json_response["labels"][2]).to eq("Week ending #{(DateTime.now - 7.days).strftime("%d %B")}")
      expect(json_response["labels"][1]).to eq("Week ending #{(DateTime.now - 14.days).strftime("%d %B")}")
      expect(json_response["labels"][0]).to eq("Week ending #{(DateTime.now - 21.days).strftime("%d %B")}")
      expect(json_response["data"].map { |actual| actual["label"] }.sort).to eq(Mobilization.mobilization_type_options.sort)
      expect(json_response["data"].map { |actual| actual["new"] }).to eq([[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,7,0,3], [0,0,0,0], [0,0,0,0], [0,0,0,0]])
      expect(json_response["data"].map { |actual| actual["participants"] }).to eq([[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,3,0,7], [0,0,0,0], [0,0,0,0], [0,0,0,0]])
    end

    it "returns quarterly data" do
      get :mobilizations, params: { dateRange: 'quarter' }
      json_response = JSON.parse(response.body)
      expect(json_response["labels"][2]).to eq("Month of #{DateTime.now.strftime("%B %Y")}")
      expect(json_response["labels"][1]).to eq("Month of #{(DateTime.now - 1.months).strftime("%B %Y")}")
      expect(json_response["labels"][0]).to eq("Month of #{(DateTime.now - 2.months).strftime("%B %Y")}")
      expect(json_response["data"].map { |actual| actual["label"] }.sort).to eq(Mobilization.mobilization_type_options.sort)
      expect(json_response["data"].map { |actual| actual["new"] }).to eq([[0,0,0], [0,0,0], [0,0,0], [0,0,0], [4,0,10], [0,0,0], [0,0,0], [0,0,0]])
      expect(json_response["data"].map { |actual| actual["participants"] }).to eq([[0,0,0], [0,0,0], [0,0,0], [0,0,0], [2,0,10], [0,0,0], [0,0,0], [0,0,0]])
    end

    it "returns bi-annual data" do
      get :mobilizations, params: { dateRange: 'half-year' }
      json_response = JSON.parse(response.body)
      expect(json_response["labels"][5]).to eq("Month of #{DateTime.now.strftime("%B %Y")}")
      expect(json_response["labels"][4]).to eq("Month of #{(DateTime.now - 1.months).strftime("%B %Y")}")
      expect(json_response["labels"][3]).to eq("Month of #{(DateTime.now - 2.months).strftime("%B %Y")}")
      expect(json_response["labels"][2]).to eq("Month of #{(DateTime.now - 3.months).strftime("%B %Y")}")
      expect(json_response["labels"][1]).to eq("Month of #{(DateTime.now - 4.months).strftime("%B %Y")}")
      expect(json_response["labels"][0]).to eq("Month of #{(DateTime.now - 5.months).strftime("%B %Y")}")
      expect(json_response["data"].map { |actual| actual["label"] }.sort).to eq(Mobilization.mobilization_type_options.sort)
      expect(json_response["data"].map { |actual| actual["new"] }).to eq([[0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,3,0,4,0,10], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0]])
      expect(json_response["data"].map { |actual| actual["participants"] }).to eq([[0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,1,0,2,0,10], [0,0,0,0,0,0], [0,0,0,0,0,0], [0,0,0,0,0,0]])
    end
  end

  def coordinator_sign_in
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in FactoryBot.create(:coordinator)
  end

  def create_mobilizations
    user = FactoryBot.create(:user, {email: 'aa@bb.com'})
    chapter = FactoryBot.create(:chapter, {name: 'hello world'})

    Mobilization.create!(
        user_id: user.id,
        chapter_id: chapter.id,
        mobilization_type: 'House Meetings',
        event_type: 'Virtual',
        participants: 7,
        new_members_sign_ons: 3,
        total_one_time_donations: 10,
        xra_donation_suscriptions: 10,
        arrestable_pledges: 10,
        xra_newsletter_sign_ups: 10
    )

    Mobilization.create!(
        user_id: user.id,
        chapter_id: chapter.id,
        mobilization_type: 'House Meetings',
        event_type: 'Virtual',
        participants: 3,
        new_members_sign_ons: 7,
        total_one_time_donations: 10,
        xra_donation_suscriptions: 10,
        arrestable_pledges: 10,
        xra_newsletter_sign_ups: 10,
        created_at: (DateTime.now - 14.days)
    )

    Mobilization.create!(
        user_id: user.id,
        chapter_id: chapter.id,
        mobilization_type: 'House Meetings',
        event_type: 'Virtual',
        participants: 2,
        new_members_sign_ons: 4,
        total_one_time_donations: 10,
        xra_donation_suscriptions: 10,
        arrestable_pledges: 10,
        xra_newsletter_sign_ups: 10,
        created_at: ((DateTime.now - 2.months) - 1.days)
    )

    Mobilization.create!(
        user_id: user.id,
        chapter_id: chapter.id,
        mobilization_type: 'House Meetings',
        event_type: 'Virtual',
        participants: 1,
        new_members_sign_ons: 3,
        total_one_time_donations: 10,
        xra_donation_suscriptions: 10,
        arrestable_pledges: 10,
        xra_newsletter_sign_ups: 10,
        created_at: ((DateTime.now - 4.months) - 1.days)
    )
  end
end
