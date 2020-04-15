require 'rails_helper'

feature 'login', :devise do

    scenario 'user has login option' do
        visit_home_page
        expect(page).to have_content "Log In"
    end

    scenario 'user redirect to login page' do
        visit_home_page
        click_link "Log In"
        expect(page).to have_content "Sign in"
        expect(page).to have_content "Forgot your password?"
    end

    scenario 'page should have username and password fields' do
        visit_sign_in_page
        expect(find_field("Email").value).to eq ''
        expect(find_field("Password").value).to eq ''
    end

    scenario 'user cannot sign in with incorrect email' do
        user = FactoryBot.create(:user)
        sign_in('invalid@email.com', user.password)
        expect(page).to have_content "Log In"
    end

    scenario 'user cannot sign in with incorrect password' do
        user = FactoryBot.create(:user)
        sign_in(user.email, 'invalidPassword')
        expect(page).to have_content "Log In"
    end

end
