require 'rails_helper'

feature 'report tiles' do
  before(:each) do
    @user = FactoryBot.create(:user, role: 'external')
    sign_in(@user.email, @user.password)
    visit reports_path
  end

  scenario 'should contain corresponding data from the tiles api' do
    expect(find('#members-total')).to have_content 1
    expect(find('#members-growth')).to have_content 7
    expect(find('#subscriptions')).to have_content "1K"
    expect(find('#arrestable-total')).to have_content 1
    expect(find('#arrestable-attrition')).to have_content 7
    expect(find('#arrests')).to have_content 10
  end
end

feature 'reports page authorization' do
  scenario 'should be accessible by external users' do
    @user = FactoryBot.create(:user, role: 'external')
    sign_in(@user.email, @user.password)
    visit reports_path
    expect(page).to have_css('.report-tiles-container')
  end

  scenario 'should be accessible by admin users' do
    @user = FactoryBot.create(:user, role: 'admin', chapter: nil)
    sign_in(@user.email, @user.password)
    visit reports_path
    expect(page).to have_css('.report-tiles-container')
  end

  # scenario 'should be accessible by reviewer users' do
  #   @user = FactoryBot.create(:user, role: 'reviewer', chapter: nil)
  #   sign_in(@user.email, @user.password)
  #   visit reports_path
  #   expect(page).to have_css('.report-tiles-container')
  # end
end