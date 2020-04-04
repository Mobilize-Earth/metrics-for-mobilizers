require 'rails_helper'

feature 'login', :devise do
    scenario 'user redirect to login' do
        Capybara.app_host = "https://reporting.dev.organise.earth/"
        visit "/"
        click_link "Sign in"
        expect(page).to have_content "Sign in"
    end
end