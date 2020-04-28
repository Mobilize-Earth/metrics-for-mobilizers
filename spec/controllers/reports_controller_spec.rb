require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe "table" do
    it "returns all countries data" do
      coordinator_sign_in
      get :table
      json_response = JSON.parse(response.body)
      expect(json_response.length).to equal(CS.countries.length)
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
      expect(json_response.length).to equal(Regions.us_regions[:region_1][:states].length)
    end
  end

  def coordinator_sign_in
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in FactoryBot.create(:coordinator)
  end
end
