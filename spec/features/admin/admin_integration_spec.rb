require 'rails_helper'

feature 'admin user', :devise do

    before(:each) do
        @user = FactoryBot.create(:user, role: 'admin', chapter: nil)
    end

    scenario 'should redirect to admin dashboard with valid credentials' do
        sign_in(@user.email, @user.password)
        expect(page).to have_content "Navigation"
    end

    scenario 'should redirect to admin dashboard when visit chapter dashboard' do
        sign_in(@user.email, @user.password)
        visit "/chapters/1"
        expect(page).to have_content "Navigation"
        expect(page).to have_content "You are not authorized to access this page."
    end

    scenario 'redirected from landing page to admin dashboard' do
        sign_in(@user.email, @user.password)
        visit_home_page
        expect(page).to have_content "Navigation"
    end

    scenario 'should not access to admin dashboard with invalid credentials' do
        sign_in('', '')
        expect(page).to have_content "Log In"
    end

end
