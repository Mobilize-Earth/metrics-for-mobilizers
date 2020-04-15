require 'rails_helper'

feature 'reporting done' do
  before(:each) do
    @user = FactoryBot.create(:user, role: 'external')
    sign_in(@user.email, @user.password)
    visit_home_page
    visit forms_index_path
  end
  scenario 'user redirected to dashboard when clicks done button' do
    click_link 'I\'m done'
    expect(page).to have_current_path dashboard_index_path, ignore_query: true
  end
end
