require 'rails_helper'

feature 'sign in', :devise do
    scenario 'user with access Dashboard page with valid credentials' do
        user = FactoryBot.create(:user)
        sign_in(user.email, user.password)
        expect(page).to have_content "Dashboard"
    end

    scenario 'user with invalid credentials does not access to Dashboard' do
        sign_in('', '')
        expect(page).to have_content "Log In"
    end

    scenario 'user cannot sigin with incorrect email' do
        user = FactoryBot.create(:user)
        sign_in('invalid@email.com', user.password)
        expect(page).to have_content "Log In"
    end

    scenario 'user cannot sigin with incorrect password' do
        user = FactoryBot.create(:user)
        sign_in(user.email, 'invalidPassword')
        expect(page).to have_content "Log In"
    end

    scenario 'login page has username and password fields' do
        visit_sign_in_page
        expect(find_field("Email").value).to eq ''
        expect(find_field("Password").value).to eq nil
    end
end
