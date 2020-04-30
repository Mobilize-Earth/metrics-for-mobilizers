require 'rails_helper'

feature 'navigation as coordinator' do
  before(:each) do
    @user = FactoryBot.create(:coordinator)
    sign_in(@user.email, @user.password)
    visit_home_page
  end

  scenario 'homepage should be chapters/show' do
    expect(page).to have_current_path '/chapters/1', ignore_query: true
  end

  scenario 'should redirect to chapter dashboard when visiting admin dashboard' do
    visit "/admins/index"
    expect(page).to have_current_path '/chapters/1', ignore_query: true
    expect(page).to have_content "You are not authorized to access this page."
  end

  scenario 'should be able to click to reports page' do
    click_on "View Reports"
    expect(page).to have_current_path '/reports', ignore_query: true
  end
end

feature 'navigation as admin' do
  before(:each) do
    @user = FactoryBot.create(:administrator)
    sign_in(@user.email, @user.password)
    visit_home_page
  end

  scenario 'homepage should be admins/index' do
    expect(page).to have_content 'Navigation'
  end

  scenario 'should redirect to admin dashboard when visiting chapter dashboard' do
    visit "/chapters/1"
    expect(page).to have_content "Navigation"
    expect(page).to have_content "You are not authorized to access this page."
  end

  scenario 'should be able to click to reports page' do
    click_on "View Reports"
    expect(page).to have_current_path '/reports', ignore_query: true
  end
end

feature 'page access' do
  scenario 'should not access to admin dashboard with invalid credentials' do
    @user = FactoryBot.create(:administrator)
    sign_in('', '')
    expect(page).to have_content "Log In"
  end
end

# feature 'navigation as reviewer' do
#   before(:each) do
#     @user = FactoryBot.create(:reviewer)
#     sign_in(@user.email, @user.password)
#     visit_home_page
#   end
#
#   scenario 'homepage should be reports' do
#     expect(page).to have_content 'Global'
#   end
# end