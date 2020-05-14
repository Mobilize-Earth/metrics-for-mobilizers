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

    scenario 'should show error if assigned chapter has 2 coordinators already' do
        # setup
        chapter = FactoryBot.create :chapter, name: 'Test chapter'
        FactoryBot.create :coordinator, chapter: chapter
        FactoryBot.create :coordinator, chapter: chapter

        # execute
        fill_in 'user_email', with: 'test1@test.com'
        select 'External Coordinator', from: 'user_role'
        select 'Test chapter'
        click_button 'Submit'
        expect(page).to have_css '.alert-danger'
    end
end

feature 'edit user' do

    before(:each) do
        @admin_user = FactoryBot.create(:administrator)
        sign_in(@admin_user.email, @admin_user.password)
        visit edit_user_path(@admin_user)
    end

    scenario 'should edit user' do
        fill_in 'user_first_name', with: 'Name edit'
        fill_in 'user_last_name', with: 'Last edit'
        fill_in 'user_phone_number', with: '123456789'
        fill_in 'user_email', with: 'test1_edited@test.com'

        click_button 'Submit'
        expect(User.last.first_name).to eq('Name edit')
        expect(User.last.last_name).to eq('Last edit')
        expect(User.last.phone_number).to eq('123456789')
        expect(User.last.email).to eq('test1_edited@test.com')
        expect(User.last.role).to eq('admin')
    end

    scenario 'should change to data reviewer role for a user saved' do
        select 'Data Reviewer', from: 'user_role'
        click_button 'Submit'
        expect(User.last.role).to eq('reviewer')
    end
end

feature 'navigation' do
    before(:each) do
        @user = FactoryBot.create(:administrator)
        sign_in(@user.email, @user.password)
        visit_home_page
    end

    scenario 'homepage should be admins/index' do
        expect(page).to have_content 'Onboarding'
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
        expect(page).to have_content 'Onboarding'
    end

    scenario 'should redirect to admin dashboard when visiting forms/index' do
        visit "/forms/index"
        expect(page).to have_content "Onboarding"
        expect(page).to have_content "You are not authorized to access this page."
    end
end

feature 'navigation' do
    scenario 'should be redirect to sign in page when access user administration page' do
        visit new_user_path
        expect(page).to have_current_path "/users/sign_in", ignore_query: true
    end
end

feature 'send email'do
    before :each do
        @admin_user = FactoryBot.create(:administrator)
        sign_in(@admin_user.email, @admin_user.password)
        find_link('link-users').click
    end
  
    scenario 'when new data reviewer is registered' do
        create_user_with_role('Data Reviewer')

        email_content = get_email_html(1)
        link_url = email_content.xpath("//a")[0][:href]
        expect(link_url).to include 'http://localhost:3000/users/invitation/accept?invitation_token='
        expect(email_content).to have_content("Accept Invitation")
        expect(email_content).to have_content("Data Reviewer")
    end

    scenario 'when new admin is registered' do
        create_user_with_role('Administrator')

        email_content = get_email_html(1)
        expect(email_content).to have_content("Administrator")
    end

    scenario 'should show errorors' do
        create_user_with_exteral_coordinator_role

        email_content = get_email_html(1)
        expect(email_content).to have_content("External Coordinator")
    end
end

feature 'resend invitation email'do
    before :each do
        @admin_user = FactoryBot.create(:administrator)
        sign_in(@admin_user.email, @admin_user.password)
        find_link('link-users').click
    end

    scenario 'should show the user created' do
        create_user_with_role('Administrator')

        expect(page).to have_content('test1@test.com')
    end

    scenario 'should show a success message when email is sended' do
        create_user_with_role('Administrator')
        find_link('resend_user_email').click

        expect(page).to have_css '.alert-success'
    end


    scenario 'should send a email when click resend link' do
        create_user_with_role('Administrator')
        find_link('resend_user_email').click

        email_content = get_email_html(2)
        link_url = email_content.xpath("//a")[0][:href]
        expect(link_url).to include 'http://localhost:3000/users/invitation/accept?invitation_token='
        expect(Devise::Mailer.deliveries.size).to eq(2)
    end
end

def create_user_with_role(role)
    fill_in 'user_email', with: 'test1@test.com'
    select role, from: 'user_role'
    click_button 'Submit'
end

def create_user_with_exteral_coordinator_role
    FactoryBot.create :chapter, name: 'Test chapter'

    fill_in 'user_email', with: 'test1@test.com'
    select 'External Coordinator', from: 'user_role'
    select 'Test chapter'
    click_button 'Submit'
end

def get_email_html(email_number)
    sleep 5 # Prevent flaky failures due to mail not being delivered yet
    email_body = Devise::Mailer.deliveries[email_number - 1].body.encoded
    Nokogiri::HTML.parse(email_body).document
end