require 'rails_helper'

feature 'external coordinator', :devise do
    before(:each) do
      @user = FactoryBot.create(:coordinator)
      sign_in(@user.email, @user.password)
      visit_home_page
    end

    scenario 'should login and redirect to external coordinator dashboard' do
        expect(page).to have_content 'Click to complete for each activity category your chapter participated in this week.'
    end

    scenario 'should redirect to external coordinator dashboard when visit admin dashboard' do
        visit "/admins/index"
        expect(page).to have_content 'Click to complete for each activity category your chapter participated in this week.'
        expect(page).to have_content "You are not authorized to access this page."
    end

    scenario 'redirected from landing page to dashboard' do
        expect(page).to have_content 'Click to complete for each activity category your chapter participated in this week.'
    end
end

feature 'external coordinator' do
    scenario 'user with invalid credentials does not access to Dashboard' do
        sign_in('', '')
        expect(page).to have_content "Log In"
    end
end