require 'rails_helper'

RSpec.describe SocialMediaBlitzingsController, type: :controller do
  before :each do
    user = FactoryBot.create(:coordinator)
    sign_in_user(user)
  end

  describe "GET new" do
    it "Assigns @types and @social_media_blitzing" do
      get :new
      expect(assigns(:types)).to eq(SocialMediaBlitzing.social_media_blitzing_type_options)
      expect(assigns(:social_media_blitzing).class).to eq(SocialMediaBlitzing)
      expect(response).to render_template("new")
    end
  end

  describe "POST create" do
    it "creates a social media blitzing" do
      report_date = Time.now
      number_of_posts = Faker::Number.number(digits: 2)
      number_of_people_posting = Faker::Number.number(digits: 2)
      params = {
          report_date: report_date,
          social_media_blitzing: {
              number_of_posts: number_of_posts,
              number_of_people_posting: number_of_people_posting
          }
      }
      post :create, params: params

      social_media_blitzing = SocialMediaBlitzing.first

      expect(social_media_blitzing.number_of_posts).to eql(number_of_posts)
      expect(social_media_blitzing.number_of_people_posting).to eql(number_of_people_posting)
      expect(response).to redirect_to(growth_activities_path)
    end
  end
end

def sign_in_user(user)
  @request.env["devise.mapping"] = Devise.mappings[:user]
  sign_in user
end