require 'rails_helper'

feature 'create user' do
    before(:each) do
        @admin_user = FactoryBot.create(:administrator)
        sign_in(@admin_user.email, @admin_user.password)
        find_link('link-users').click
    end

    scenario 'should have chapter role selection disabled' do
        expect(page).to have_field('user_chapter_id', :type => 'select', :disabled => true)
    end

    scenario 'should show error messages when do not complete information' do
        click_button 'Submit'
        expect(page).to have_css '.alert-danger'
    end

    scenario 'should create user' do
        fill_in 'user_email', with: 'test1@test.com'
        click_button 'Submit'
        expect(User.last.email).to eq('test1@test.com')
    end

    scenario 'should show success message when user is created' do
        fill_in 'user_email', with: 'test1@test.com'
        click_button 'Submit'
        expect(page).to have_css '.alert-success'
    end

    scenario 'should make chapter required when external role is selected' do
        fill_in 'user_email', with: 'test1@test.com'
        select 'External Coordinator', from: 'user_role'
        click_button 'Submit'
        expect(page).to have_css '.alert-danger'
    end

    scenario 'should have chapter role selection enabled' do
        fill_in 'user_email', with: 'test1@test.com'
        select 'External Coordinator', from: 'user_role'
        expect(page).to have_field('user_chapter_id', :type => 'select', :disabled => false)
    end

    scenario 'should save if user is not external and chapter is not specified' do
        fill_in 'user_email', with: 'test1@test.com'
        select 'Administrator', from: 'user_role'
        click_button 'Submit'
        expect(page).to have_css '.alert-success'
    end
end

feature 'edit user' do

    before(:each) do
        @admin_user = FactoryBot.create(:administrator)
        sign_in(@admin_user.email, @admin_user.password)
        visit edit_user_path(@admin_user)
    end

    scenario 'should edit user' do
        fill_in 'user_email', with: 'test1_edited@test.com'
        click_button 'Submit'
        expect(User.last.email).to eq('test1_edited@test.com')
    end
end

feature 'navigation' do
    before(:each) do
        @user = FactoryBot.create(:administrator)
        sign_in(@user.email, @user.password)
        visit_home_page
    end

    scenario 'homepage should be admins/index' do
        expect(page).to have_content 'Navigation'
    end

    scenario 'should access create user page with correct credentials' do
        find_link('link-users').click
        expect(page).to have_current_path new_user_path, ignore_query: true
    end

    scenario 'should access edit user page with correct credentials' do
        visit edit_user_path(@user)
        expect(page).to have_current_path edit_user_path(@user), ignore_query: true
    end

    scenario 'should be able to click to reports page and back to onboarding' do
        click_on "View Reports"
        expect(page).to have_current_path '/reports', ignore_query: true
        click_on "Onboarding"
        expect(page).to have_content 'Navigation'
    end

    scenario 'should redirect to admin dashboard when visiting forms/index' do
        visit "/forms/index"
        expect(page).to have_content "Navigation"
        expect(page).to have_content "You are not authorized to access this page."
    end
end

feature 'navigation' do
    scenario 'should be redirect to sign in page when access user administration page' do
        visit new_user_path
        expect(page).to have_current_path "/users/sign_in", ignore_query: true
    end
end

feature 'send mail'do
    before :each do
        @admin_user = FactoryBot.create(:administrator)
        sign_in(@admin_user.email, @admin_user.password)
        find_link('link-users').click
        fill_in 'user_email', with: 'test1@test.com'
    end
  
    it "when new data reviewer is registered" do
        click_button 'Submit'
      
        email_content = UserMailer.deliveries[0].body.encoded
        #expect(email_content).to include '<a href=3D"http://localhost:3000/users/invitation/accept?invitation_token='
        expect(email_content).to have_content("Accept Invitation")
        expect(email_content).to have_content("Data Reviewer")
    end

    it "when new admin is registered" do
        select 'Administrator', from: 'user_role'
        click_button 'Submit'
      
        email_content = UserMailer.deliveries[0].body.encoded
        expect(email_content).to have_content("Administrator")
    end
  end