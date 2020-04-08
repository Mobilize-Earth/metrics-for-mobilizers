require 'rails_helper'

feature 'logged in', :devise do
    scenario 'user redirected from landing page to dashboard' do
        user = FactoryBot.create(:user)
        sign_in(user.email, user.password)
        visit_home_page
        expect(page).to have_content "Dashboard"
    end
end
