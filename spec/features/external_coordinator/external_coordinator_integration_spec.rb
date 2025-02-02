require 'rails_helper'

feature 'external coordinator', :devise do
    before(:each) do
      @user = FactoryBot.create(:coordinator)
      sign_in(@user.email, @user.password)
      visit_home_page
    end

    scenario 'should login and redirect to external coordinator dashboard' do
        expect(page).to have_content 'Click cards below complete each category and build your weekly report.'
    end

    scenario 'should redirect to external coordinator dashboard when visit admin dashboard' do
        visit "/admins/index"
        expect(page).to have_content 'Click cards below complete each category and build your weekly report.'
        expect(page).to have_content "You are not authorized to access this page."
    end

    scenario 'should be able to click to reports page and back to forms' do
        click_on "View Reports"
        expect(page).to have_current_path '/reports', ignore_query: true
        click_on "Report Entry"
        expect(page).to have_content 'Click cards below complete each category and build your weekly report.'
    end
end

feature 'external coordinator' do
    scenario 'user with invalid credentials does not access to Dashboard' do
        sign_in('', '')
        expect(page).to have_content "Log In"
    end
end