require 'rails_helper'

feature 'navigation' do
  before(:each) do
    @user = FactoryBot.create(:user, role: 'external')
    sign_in(@user.email, @user.password)
    visit_home_page
  end
  scenario 'user should be redirected to dashboard when clicks home button' do
    visit forms_index_path
    find('.test-home').click
    expect(page).to have_current_path '/chapters/1', ignore_query: true
  end
end
