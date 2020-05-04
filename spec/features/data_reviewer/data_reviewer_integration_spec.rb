require 'rails_helper'

feature 'data reviewer', :devise do
    before(:each) do
      @user = FactoryBot.create(:reviewer)
      sign_in(@user.email, @user.password)
      visit_home_page
    end

    scenario 'should login and redirect to reports page' do
        expect(page).to have_content 'Global'
    end

    scenario 'should redirect to reports view when visit admin dashboard' do
        visit "/admins/index"
        expect(page).to have_content 'Global'
    end

    scenario 'should redirect to reports view when visit forms page' do
        visit "/forms/index"
        expect(page).to have_content 'Global'
    end

    scenario 'should be able to click to reports page and back to forms' do
        click_on "View Reports"
        expect(page).to have_content 'Global'
    end
end