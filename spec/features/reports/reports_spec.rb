require 'rails_helper'

feature 'report tiles' do
  before(:each) do
    @user = FactoryBot.create(:user, role: 'external')
    sign_in(@user.email, @user.password)
    visit reports_path
  end

  scenario 'should contain corresponding data from the tiles api' do
    expect(find('#members')).to have_content 5
    expect(find('#chapters')).to have_content 1
    expect(find('#actions')).to have_content 0
    expect(find('#trainings')).to have_content 0
    expect(find('#mobilizations')).to have_content 0
    expect(find('#subscriptions')).to have_content 0
    expect(find('#pledges-arrestable')).to have_content 0
    expect(find('.report-page-subtitle .report-page-start-date')).to have_content (DateTime.now - 7.days).strftime("%d %B %Y")
    expect(find('.report-page-subtitle .report-page-end-date')).to have_content DateTime.now.strftime("%d %B %Y")
  end

  scenario 'should filter data by month' do
    find('#filter-month').click

    expect(find('#members')).to have_content 5
    expect(find('#chapters')).to have_content 1
    expect(find('#actions')).to have_content 0
    expect(find('#trainings')).to have_content 0
    expect(find('#mobilizations')).to have_content 0
    expect(find('#subscriptions')).to have_content 0
    expect(find('#pledges-arrestable')).to have_content 0
    expect(find('.report-page-subtitle .report-page-start-date')).to have_content (DateTime.now - 30.days).strftime("%d %B %Y")
    expect(find('.report-page-subtitle .report-page-end-date')).to have_content DateTime.now.strftime("%d %B %Y")
  end

  scenario 'should filter data by quarter' do
    find('#filter-quarter').click

    expect(find('#members')).to have_content 5
    expect(find('#chapters')).to have_content 1
    expect(find('#actions')).to have_content 0
    expect(find('#trainings')).to have_content 0
    expect(find('#mobilizations')).to have_content 0
    expect(find('#subscriptions')).to have_content 0
    expect(find('#pledges-arrestable')).to have_content 0
    expect(find('.report-page-subtitle .report-page-start-date')).to have_content (DateTime.now - 90.days).strftime("%d %B %Y")
    expect(find('.report-page-subtitle .report-page-end-date')).to have_content DateTime.now.strftime("%d %B %Y")
  end

  scenario 'should filter data by half year' do
    find('#filter-half-year').click

    expect(find('#members')).to have_content 5
    expect(find('#chapters')).to have_content 1
    expect(find('#actions')).to have_content 0
    expect(find('#trainings')).to have_content 0
    expect(find('#mobilizations')).to have_content 0
    expect(find('#subscriptions')).to have_content 0
    expect(find('#pledges-arrestable')).to have_content 0
    expect(find('.report-page-subtitle .report-page-start-date')).to have_content (DateTime.now - 180.days).strftime("%d %B %Y")
    expect(find('.report-page-subtitle .report-page-end-date')).to have_content DateTime.now.strftime("%d %B %Y")
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