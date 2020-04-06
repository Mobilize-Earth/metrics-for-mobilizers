require 'rails_helper'

feature 'sign in', :devise do
    scenario 'user with access Dashboard page with valid credentials' do
        user = FactoryBot.create(:user)
        signin(user.email, user.password)
        expect(page).to have_content "Dashboard"
    end

    scenario 'user with invalid credentials does not access to Dashboard' do
        signin('', '')
        expect(page).to have_content "Sign in"
    end
end
