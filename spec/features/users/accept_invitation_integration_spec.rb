require 'rails_helper'

feature 'navigation' do
    before(:each) do
        create_user
        visit_accept_invitation_page
    end

    scenario 'should navigate to accept page when user click Accept Invitation' do        
        expect(page).to have_current_path accept_user_invitation_path, ignore_query: true
    end


    scenario 'should navigate to main page when user click cancel option' do      
        click_on 'Cancel'
        expect(page).to have_current_path root_path, ignore_query: true
    end

    scenario 'should have all fields' do
        expect(page).to have_css("input#user_first_name")
        expect(page).to have_css("input#user_last_name")
        expect(page).to have_css("input#user_phone_number")
        expect(page).to have_css("input#user_password")
        expect(page).to have_css("input#user_password_confirmation")
    end
end

feature 'accept invitation' do
    before (:each) do
        create_user
        visit_accept_invitation_page
    end

    scenario 'should save on database the data' do
        fill_in 'user_first_name', with: 'Name'
        fill_in 'user_last_name', with: 'Last'
        fill_in 'user_phone_number', with: '123456789'
        fill_in 'user_password', with: '123456'
        fill_in 'user_password_confirmation', with: '123456'
        click_on 'Submit'
        expect(User.last.first_name).to eq('Name')
        expect(User.last.last_name).to eq('Last')
        expect(User.last.phone_number).to eq('123456789')
    end

    scenario 'should access to data reviewer page' do
        fill_in 'user_first_name', with: 'Name'
        fill_in 'user_last_name', with: 'Last'
        fill_in 'user_phone_number', with: '123456789'
        fill_in 'user_password', with: '123456'
        fill_in 'user_password_confirmation', with: '123456'
        click_on 'Submit'
        expect(page).to have_current_path root_path, ignore_query: true
    end

    scenario 'should not update user when there are errors' do
        fill_in 'user_first_name', with: 'Name'
        click_on 'Submit'
        expect(User.last.first_name).to eq(nil)
    end

    scenario 'should show error messages' do
        click_on 'Submit'
        expect(page).to have_css '.alert-danger'
    end
end

def create_user
    @admin_user = FactoryBot.create(:administrator)
    sign_in(@admin_user.email, @admin_user.password)
    find_link('link-users').click
    fill_in 'user_email', with: 'test1@test.com'
    click_button 'Submit'
    find('#dropdown-menu-link').click
    find('#log-out-link').click
end

def visit_accept_invitation_page
    user = User.last
    user.deliver_invitation
    visit accept_user_invitation_path + '?invitation_token='  + user.raw_invitation_token
end
