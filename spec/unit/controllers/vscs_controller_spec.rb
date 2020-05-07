require 'rails_helper'

RSpec.describe CsvsController, type: :controller do
  describe "download" do
    it "returns a CSV file for admins" do
      sign_in_user(FactoryBot.create(:administrator))
      get :download

      expect(response.header["Content-Type"]).to eq("application/zip")
      expect(response.header["Content-Disposition"]).to include("all-data-#{Date.today}.zip")
    end


    it "returns a 405 response for coordinators" do
      sign_in_user(FactoryBot.create(:coordinator))
      get :download
      expect(response).to have_http_status(405)
    end

    it "returns a 405 response for reviewers" do
      sign_in_user(FactoryBot.create(:reviewer))
      get :download
      expect(response).to have_http_status(405)
    end
  end

  def sign_in_user(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end
end
