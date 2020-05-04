require 'rails_helper'

feature 'reports breadcrumbs' do
  before(:each) do
    @user = FactoryBot.create(:coordinator)
    sign_in(@user.email, @user.password)
  end

  scenario 'should not be visible on page load' do
    visit reports_path
    expect(page).to have_selector('#report-page-breadcrumbs', visible: false)
  end

  scenario 'should show Global and Country on country filter' do
    visit reports_path(country: 'US')
    expect(find('#report-breadcrumb-global')).to have_content 'Global'
    expect(find('#report-breadcrumb-country')).to have_content 'United States'
  end

  scenario 'should show Global, Country and Region on region filter' do
    visit reports_path(country: 'US', region: 'region_1')
    expect(find('#report-breadcrumb-global')).to have_content 'Global'
    expect(find('#report-breadcrumb-country')).to have_content 'United States'
    expect(find('#report-breadcrumb-region')).to have_content 'Upper East'
  end

  scenario 'should show Global, Country, Region and State on US state filter' do
    visit reports_path(country: 'US', region: 'region_1', state: 'New York')
    expect(find('#report-breadcrumb-global')).to have_content 'Global'
    expect(find('#report-breadcrumb-country')).to have_content 'United States'
    expect(find('#report-breadcrumb-region')).to have_content 'Upper East'
    expect(find('#report-breadcrumb-state')).to have_content 'New York'
  end

  scenario 'should show Global, Country, Region and State on on-US state filter' do
    visit reports_path(country: 'AU', state: 'New South Wales')
    expect(find('#report-breadcrumb-global')).to have_content 'Global'
    expect(find('#report-breadcrumb-country')).to have_content 'Australia'
    expect(find('#report-breadcrumb-state')).to have_content 'New South Wales'
    expect(page).to have_selector('#report-breadcrumb-region', visible: false)
  end

  scenario 'should show Global, Country, Region and State on US chapter filter' do
    chapter = Chapter.find(1)
    visit reports_path(country: 'US', region: 'region_1', state: 'New York', chapter: chapter.id)
    expect(find('#report-breadcrumb-global')).to have_content 'Global'
    expect(find('#report-breadcrumb-country')).to have_content 'United States'
    expect(find('#report-breadcrumb-region')).to have_content 'Upper East'
    expect(find('#report-breadcrumb-state')).to have_content 'New York'
    expect(find('#report-breadcrumb-chapter')).to have_content chapter.name
  end

  scenario 'should show Global, Country, Region and State on on-US chapter filter' do
    chapter = Chapter.find(1)
    visit reports_path(country: 'AU', state: 'New South Wales', chapter: chapter.id)
    expect(find('#report-breadcrumb-global')).to have_content 'Global'
    expect(find('#report-breadcrumb-country')).to have_content 'Australia'
    expect(find('#report-breadcrumb-state')).to have_content 'New South Wales'
    expect(find('#report-breadcrumb-chapter')).to have_content chapter.name
    expect(page).to have_selector('#report-breadcrumb-region', visible: false)
  end
end

feature 'report tiles' do
  before(:each) do
    @user = FactoryBot.create(:coordinator)
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
    expect(find('.report-page-subtitle .report-page-start-date')).to have_content (DateTime.now - 6.days).strftime("%d %B %Y")
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
    expect(find('.report-page-subtitle .report-page-start-date')).to have_content (DateTime.now - 29.days).strftime("%d %B %Y")
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
    expect(find('.report-page-subtitle .report-page-start-date')).to have_content (DateTime.now - 89.days).strftime("%d %B %Y")
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
    expect(find('.report-page-subtitle .report-page-start-date')).to have_content (DateTime.now - 179.days).strftime("%d %B %Y")
    expect(find('.report-page-subtitle .report-page-end-date')).to have_content DateTime.now.strftime("%d %B %Y")
  end
end

feature 'mobilization chart' do
  before(:each) do
    create_mobilizations
    @user = FactoryBot.create(:coordinator)
    sign_in(@user.email, @user.password)
    visit reports_path
  end

  scenario 'should render metrics' do
    page.assert_selector('.metric', count: 9)

    expected = Mobilization.mobilization_type_options.push('Total Participants')
    expect(page.all('.metric').map{ |metric| metric.find('.subtitle').native.text }.sort).to eq(expected.sort)

    page.all('.metric').each do |metric|
      metric_label = metric.find('.subtitle').native.text

      if metric_label == "Total Participants"
        expect(metric).to have_content "Represents total grouped activity"
      elsif metric_label == "House Meetings"
        expect(metric).to have_content 3
      else
        expect(metric).to have_content 0
      end
    end
  end
end

feature 'reports page authorization' do
  scenario 'should be accessible by external users' do
    @user = FactoryBot.create(:coordinator)
    sign_in(@user.email, @user.password)
    visit reports_path
    expect(page).to have_css('.report-tiles-container')
  end

  scenario 'should be accessible by admin users' do
    @user = FactoryBot.create(:administrator)
    sign_in(@user.email, @user.password)
    visit reports_path
    expect(page).to have_css('.report-tiles-container')
  end

  # scenario 'should be accessible by reviewer users' do
  #   @user = FactoryBot.create(:reviewer)
  #   sign_in(@user.email, @user.password)
  #   visit reports_path
  #   expect(page).to have_css('.report-tiles-container')
  # end
end

def create_mobilizations
  user = FactoryBot.create(:user, {email: 'aa@bb.com'})
  chapter = FactoryBot.create(:chapter, {name: 'hello world'})

  Mobilization.create!(
      user_id: user.id,
      chapter_id: chapter.id,
      mobilization_type: 'House Meetings',
      event_type: 'Virtual',
      participants: 7,
      new_members_sign_ons: 3,
      total_one_time_donations: 10,
      xra_donation_suscriptions: 10,
      arrestable_pledges: 10,
      xra_newsletter_sign_ups: 10
  )

  Mobilization.create!(
      user_id: user.id,
      chapter_id: chapter.id,
      mobilization_type: 'House Meetings',
      event_type: 'Virtual',
      participants: 1,
      new_members_sign_ons: 7,
      total_one_time_donations: 10,
      xra_donation_suscriptions: 10,
      arrestable_pledges: 10,
      xra_newsletter_sign_ups: 10,
      created_at: (DateTime.now - 14.days)
  )

  Mobilization.create!(
      user_id: user.id,
      chapter_id: chapter.id,
      mobilization_type: 'House Meetings',
      event_type: 'Virtual',
      participants: 2,
      new_members_sign_ons: 4,
      total_one_time_donations: 10,
      xra_donation_suscriptions: 10,
      arrestable_pledges: 10,
      xra_newsletter_sign_ups: 10,
      created_at: ((DateTime.now - 2.months) - 1.days)
  )

  Mobilization.create!(
      user_id: user.id,
      chapter_id: chapter.id,
      mobilization_type: 'House Meetings',
      event_type: 'Virtual',
      participants: 1,
      new_members_sign_ons: 3,
      total_one_time_donations: 10,
      xra_donation_suscriptions: 10,
      arrestable_pledges: 10,
      xra_newsletter_sign_ups: 10,
      created_at: ((DateTime.now - 4.months) - 1.days)
  )
end