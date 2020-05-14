require 'rails_helper'

feature 'reports breadcrumbs' do
  before(:each) do
    @user = FactoryBot.create(:coordinator)
    sign_in(@user.email, @user.password)
  end

  scenario 'should not be visible on page load' do
    visit reports_path
    expect(page).to have_selector('#report-page-breadcrumbs', visible: false)
    expect(find('#report-page-title')).to have_content 'Global'
  end

  scenario 'should show Global and Country on country filter' do
    visit reports_path(country: 'US')
    expect(find('#report-breadcrumb-global')).to have_content 'Global'
    expect(find('#report-breadcrumb-country')).to have_content 'United States'
    expect(find('#report-page-title')).to have_content 'United States'
  end

  scenario 'should show Global, Country and Region on region filter' do
    visit reports_path(country: 'US', region: 'region_1')
    expect(find('#report-breadcrumb-global')).to have_content 'Global'
    expect(find('#report-breadcrumb-country')).to have_content 'United States'
    expect(find('#report-breadcrumb-region')).to have_content 'Upper East'
    expect(find('#report-page-title')).to have_content 'Upper East'
  end

  scenario 'should show Global, Country, Region and State on US state filter' do
    visit reports_path(country: 'US', region: 'region_1', state: 'New York')
    expect(find('#report-breadcrumb-global')).to have_content 'Global'
    expect(find('#report-breadcrumb-country')).to have_content 'United States'
    expect(find('#report-breadcrumb-region')).to have_content 'Upper East'
    expect(find('#report-breadcrumb-state')).to have_content 'New York'
    expect(find('#report-page-title')).to have_content 'New York'
  end

  scenario 'should show Global, Country, Region and State on on-US state filter' do
    visit reports_path(country: 'AU', state: 'New South Wales')
    expect(find('#report-breadcrumb-global')).to have_content 'Global'
    expect(find('#report-breadcrumb-country')).to have_content 'Australia'
    expect(find('#report-breadcrumb-state')).to have_content 'New South Wales'
    expect(find('#report-page-title')).to have_content 'New South Wales'
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
    expect(find('#report-page-title')).to have_content chapter.name
  end

  scenario 'should show Global, Country, Region and State on on-US chapter filter' do
    chapter = Chapter.find(1)
    visit reports_path(country: 'AU', state: 'New South Wales', chapter: chapter.id)
    expect(find('#report-breadcrumb-global')).to have_content 'Global'
    expect(find('#report-breadcrumb-country')).to have_content 'Australia'
    expect(find('#report-breadcrumb-state')).to have_content 'New South Wales'
    expect(find('#report-breadcrumb-chapter')).to have_content chapter.name
    expect(find('#report-page-title')).to have_content chapter.name
    expect(page).to have_selector('#report-breadcrumb-region', visible: false)
  end
end

feature 'reports csv download' do
  scenario 'should not render for coordinator' do
    @user = FactoryBot.create(:coordinator)
    sign_in(@user.email, @user.password)
    visit reports_path
    expect(page).not_to have_selector("#csv-download")
  end

  scenario 'should not render for reviewer' do
    @user = FactoryBot.create(:reviewer)
    sign_in(@user.email, @user.password)
    visit reports_path
    expect(page).not_to have_selector("#csv-download")
  end

  scenario 'should render for admin' do
    @user = FactoryBot.create(:administrator)
    sign_in(@user.email, @user.password)
    visit reports_path
    expect(page).to have_selector("#csv-download")
  end
end

feature 'report tiles' do
  before(:each) do
    @user = FactoryBot.create(:coordinator)
    sign_in(@user.email, @user.password)
    visit reports_path
  end

  scenario 'should contain corresponding data from the tiles api' do
    expect(find('#members')).to have_content @user.chapter.total_mobilizers
    expect(find('#chapters')).to have_content 1
    expect(find('#actions')).to have_content 0
    expect(find('#trainings')).to have_content 0
    expect(find('#mobilizations')).to have_content 0
    expect(find('#subscriptions')).to have_content @user.chapter.total_subscription_amount.to_int
    expect(find('#arrestable-pledges')).to have_content @user.chapter.total_arrestable_pledges
    expect(find('.report-page-subtitle .report-page-start-date')).to have_content (DateTime.now - 6.days).strftime("%d %B %Y")
    expect(find('.report-page-subtitle .report-page-end-date')).to have_content DateTime.now.strftime("%d %B %Y")
  end

  scenario 'should filter data by month' do
    find('#filter-month').click
    expect(find('#members')).to have_content @user.chapter.total_mobilizers
    expect(find('#chapters')).to have_content 1
    expect(find('#actions')).to have_content 0
    expect(find('#trainings')).to have_content 0
    expect(find('#mobilizations')).to have_content 0
    expect(find('#subscriptions')).to have_content @user.chapter.total_subscription_amount.to_int
    expect(find('#arrestable-pledges')).to have_content @user.chapter.total_arrestable_pledges
    expect(find('.report-page-subtitle .report-page-start-date')).to have_content (DateTime.now - 29.days).strftime("%d %B %Y")
    expect(find('.report-page-subtitle .report-page-end-date')).to have_content DateTime.now.strftime("%d %B %Y")
  end

  scenario 'should filter data by quarter' do
    find('#filter-quarter').click

    expect(find('#members')).to have_content @user.chapter.total_mobilizers
    expect(find('#chapters')).to have_content 1
    expect(find('#actions')).to have_content 0
    expect(find('#trainings')).to have_content 0
    expect(find('#mobilizations')).to have_content 0
    expect(find('#subscriptions')).to have_content @user.chapter.total_subscription_amount.to_int
    expect(find('#arrestable-pledges')).to have_content @user.chapter.total_arrestable_pledges
    expect(find('.report-page-subtitle .report-page-start-date')).to have_content (DateTime.now - 89.days).strftime("%d %B %Y")
    expect(find('.report-page-subtitle .report-page-end-date')).to have_content DateTime.now.strftime("%d %B %Y")
  end

  scenario 'should filter data by half year' do
    find('#filter-half-year').click

    expect(find('#members')).to have_content @user.chapter.total_mobilizers
    expect(find('#chapters')).to have_content 1
    expect(find('#actions')).to have_content 0
    expect(find('#trainings')).to have_content 0
    expect(find('#mobilizations')).to have_content 0
    expect(find('#subscriptions')).to have_content @user.chapter.total_subscription_amount.to_int
    expect(find('#arrestable-pledges')).to have_content @user.chapter.total_arrestable_pledges
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

    expected = GrowthActivity.growth_activity_type_options.push('People Engaged')
    expect(page.all('.metric').map{ |metric| metric.find('.subtitle').native.text }.sort).to eq(expected.sort)

    page.all('.metric').each do |metric|
      metric_label = metric.find('.subtitle').native.text

      if metric_label == "People Engaged"
        expect(metric).to have_content "Total grouped activity"
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

feature 'table' do
  before(:each) do
    @user = FactoryBot.create(:coordinator)
    # We have to add an address to coordinator chapter
    first_chapter = Chapter.first
    FactoryBot.create :us_address, chapter: first_chapter

    sign_in(@user.email, @user.password)
  end

  feature 'showing all data' do
    before(:each) do
      @us_chapter = FactoryBot.create :chapter, name: 'us chapter', total_mobilizers: 100
      FactoryBot.create :us_address, chapter: @us_chapter

      @mx_chapter = FactoryBot.create :chapter, name: 'mx chapter', total_mobilizers: 50
      FactoryBot.create :address, country: 'Mexico', chapter: @mx_chapter

      visit reports_path
      find('.report-table > tbody tr:nth-child(1)') # wait to have this element in the DOM, to be sure click handlers have been registered
    end

    scenario 'should contain data group by country' do
      records = find('.report-table > tbody')
      expect(records).to have_text 'United States'
      expect(records).to have_text 'Mexico'
    end

    scenario 'should be sorted by mobilizers' do
      records = find('.report-table > tbody')
      expect(records.find('tr:nth-child(1)')).to have_text 'United States'
      expect(records.find('tr:nth-child(2)')).to have_text 'Mexico'
    end

    scenario 'should sort by country when click on country header' do
      find('.report-table', text: 'Countries').click

      records = find('.report-table > tbody')
      expect(records.find('tr:nth-child(1)')).to have_text 'Mexico'
      expect(records.find('tr:nth-child(2)')).to have_text 'United States'
    end

    scenario 'should show expected data' do
      @mx_chapter.update(total_mobilizers: 2, total_subscription_amount: 3, total_arrestable_pledges:4)
      FactoryBot.create_list(:growth_activity, 5, chapter: @mx_chapter, newsletter_sign_ups:1)
      FactoryBot.create_list(:training, 6, chapter: @mx_chapter, user: @user)
      FactoryBot.create_list(:arrestable_action, 8, chapter: @mx_chapter, user: @user)

      visit reports_path

      mx_records = find('.report-table > tbody tr', text: 'Mexico')
      expect(mx_records.find('td:nth-child(2)')).to have_text '1'
      expect(mx_records.find('td:nth-child(3)')).to have_text '2'
      expect(mx_records.find('td:nth-child(4)')).to have_text '3'
      expect(mx_records.find('td:nth-child(5)')).to have_text '4'
      expect(mx_records.find('td:nth-child(6)')).to have_text '5'
      expect(mx_records.find('td:nth-child(7)')).to have_text '6'
      expect(mx_records.find('td:nth-child(8)')).to have_text '5'
      expect(mx_records.find('td:nth-child(9)')).to have_text '8'
    end
  end


end

def create_mobilizations
  user = FactoryBot.create(:user, {email: 'aa@bb.com'})
  chapter = FactoryBot.create(:chapter, {name: 'hello world'})

  GrowthActivity.create!(
      user_id: user.id,
      chapter_id: chapter.id,
      growth_activity_type: 'House Meetings',
      event_type: 'Virtual',
      participants: 7,
      new_mobilizer_sign_ons: 3,
      total_donation_subscriptions: 10,
      total_one_time_donations: 10,
      donation_subscriptions: 10,
      arrestable_pledges: 10,
      newsletter_sign_ups: 10
  )

  GrowthActivity.create!(
      user_id: user.id,
      chapter_id: chapter.id,
      growth_activity_type: 'House Meetings',
      event_type: 'Virtual',
      participants: 1,
      new_mobilizer_sign_ons: 7,
      total_donation_subscriptions: 10,
      total_one_time_donations: 10,
      donation_subscriptions: 10,
      arrestable_pledges: 10,
      newsletter_sign_ups: 10,
      created_at: (DateTime.now - 14.days)
  )

  GrowthActivity.create!(
      user_id: user.id,
      chapter_id: chapter.id,
      growth_activity_type: 'House Meetings',
      event_type: 'Virtual',
      participants: 2,
      new_mobilizer_sign_ons: 4,
      total_donation_subscriptions: 10,
      total_one_time_donations: 10,
      donation_subscriptions: 10,
      arrestable_pledges: 10,
      newsletter_sign_ups: 10,
      created_at: ((DateTime.now - 2.months) - 1.days)
  )

  GrowthActivity.create!(
      user_id: user.id,
      chapter_id: chapter.id,
      growth_activity_type: 'House Meetings',
      event_type: 'Virtual',
      participants: 1,
      new_mobilizer_sign_ons: 3,
      total_donation_subscriptions: 10,
      total_one_time_donations: 10,
      donation_subscriptions: 10,
      arrestable_pledges: 10,
      newsletter_sign_ups: 10,
      created_at: ((DateTime.now - 4.months) - 1.days)
  )
end