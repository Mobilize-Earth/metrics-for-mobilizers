require 'rails_helper'

feature 'external coordinator', :devise do

    before(:each) do
        @user = FactoryBot.create(:user, role: 'external')
    end
    
    scenario 'should login and redirect to external coordinator dashboard' do
        sign_in(@user.email, @user.password)
        expect(page).to have_content "Dashboard"
    end

    scenario 'should redirect to external coordinator dashboard when visit admin dashboard' do
        sign_in(@user.email, @user.password)
        visit "/admins/index"
        expect(page).to have_content "Dashboard"
    end
    
    scenario 'redirected from landing page to dashboard' do
        sign_in(@user.email, @user.password)
        visit_home_page
        expect(page).to have_content "Dashboard"
    end
    
    scenario 'user with invalid credentials does not access to Dashboard' do
        sign_in('', '')
        expect(page).to have_content "Log In"
    end
end
