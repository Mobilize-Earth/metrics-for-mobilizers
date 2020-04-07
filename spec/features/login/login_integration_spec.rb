require 'rails_helper'

feature 'login', :devise do
    scenario 'user redirect to login page' do
        visit_home_page
        click_link "Log In"
        expect(page).to have_content "Log In"
        expect(page).to have_content "Forgot your password?"
    end

    scenario 'user access login page' do
        visit_home_page
        expect(page).to have_content "Log In"
    end
end
