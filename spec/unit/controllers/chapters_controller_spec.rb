require 'rails_helper'

RSpec.describe ChaptersController, type: :controller do
  describe "show" do
    it "does not go to chapter dashboard when not signed in as coordinator" do
      get :show, params: { id: 1 }
      expect(response).not_to render_template(:show)
      expect(response).not_to render_template(:new)
      expect(response).not_to render_template(:edit)
    end

    it "goes to chapter dashboard when signed in as a coordinator" do
      coordinator_sign_in
      get :show, params: { id: 1 }
      expect(response).to render_template(:show)
    end
  end

  def coordinator_sign_in
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in FactoryBot.create(:coordinator)
  end
end
