require 'rails_helper'

RSpec.describe ChaptersController, type: :controller do
  before :each do
    user = FactoryBot.create(:administrator)
    sign_in_user(user)

    @name = 'Chapter 1'
    @total_mobilizers = Faker::Number.number(digits: 2)
    @total_subscription_amount =  Faker::Number.decimal(l_digits: 2, r_digits: 2)
    @total_arrestable_pledges = Faker::Number.number(digits: 2)
    @country = 'United States'
    @state_province = 'New York'
    @city = 'Brooklyn'
    @zip_code = '11211'

    @chapter_params = {
        name: @name,
        total_mobilizers: @total_mobilizers,
        total_subscription_amount: @total_subscription_amount,
        total_arrestable_pledges: @total_arrestable_pledges,
        address_attributes: {
            country: @country,
            state_province: @state_province,
            city: @city,
            zip_code: @zip_code
        }
    }
  end

  describe "GET new" do
    it "Assigns @current_coordinators and @countries" do
      get :new
      expect(assigns(:current_coordinators)).to eq(User.none)
      expect(assigns(:countries)).to eq(CS.get.to_a.sort { |a, b| a[1] <=> b[1]})
      expect(response).to render_template("new")
    end
  end

  describe "POST create" do
    it "creates a chapter" do
      post :create, params: { chapter: @chapter_params }

      chapter = Chapter.first

      expect(chapter.name).to eql(@name)
      expect(chapter.total_mobilizers).to eql(@total_mobilizers)
      expect(chapter.total_subscription_amount.to_f).to eql(@total_subscription_amount)
      expect(chapter.total_arrestable_pledges).to eql(@total_arrestable_pledges)
      expect(chapter.address.country).to eql(@country)
      expect(chapter.address.state_province).to eql(@state_province)
      expect(chapter.address.city).to eql(@city)
      expect(chapter.address.zip_code).to eql(@zip_code)
      expect(response).to redirect_to(admins_index_path)
    end

    it "throws a error when chapter already has name taken" do
      FactoryBot.create(:chapter, name: @name)

      post :create, params: { chapter: @chapter_params }
      
      expect(assigns(:chapter).errors.messages[:name][0]).to eql("Chapter Name is already taken")
      expect(response).to render_template("new")
    end
  end

  describe "GET edit" do
    it "Assigns @chapter and @current_coordinators" do
      users = [FactoryBot.create(:coordinator)]
      chapter = FactoryBot.create(:chapter, name: "Some Chapter", users: users)

      get :edit, params: {id: 2}

      expect(assigns(:chapter)).to eq(chapter)
      expect(assigns(:current_coordinators)).to eq(users)
      expect(response).to render_template("edit")
    end
  end

  describe "POST update" do
    it "updates a chapter" do
      chapter = FactoryBot.create(:chapter, name: "Some Chapter")
      new_name = 'A New Chapter Name'
      @chapter_params[:name] = new_name

      post :update, params: {id: chapter.id, chapter: @chapter_params }

      updated_chapter = Chapter.find(chapter.id)

      expect(updated_chapter.name).to eql(new_name)
      expect(response).to redirect_to(admins_index_path)
    end

    it "throws a error when chapter already has name taken" do
      chapter_1 = FactoryBot.create(:chapter, name: @name)

      new_name = 'A New Chapter Name'
      chapter = FactoryBot.create(:chapter, name: new_name)
      @chapter_params[:name] = new_name

      post :update, params: { id: chapter_1.id, chapter: @chapter_params }

      expect(assigns(:chapter).errors.messages[:name][0]).to eql("Chapter Name is already taken")
      expect(response).to redirect_to(edit_chapter_path(chapter_1.id))
    end
  end
end

def sign_in_user(user)
  @request.env["devise.mapping"] = Devise.mappings[:user]
  sign_in user
end
