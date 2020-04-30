require 'rails_helper'

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