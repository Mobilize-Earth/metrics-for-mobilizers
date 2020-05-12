require 'rails_helper'

feature 'submitting street swarm' do

  before(:each) do
    @user = FactoryBot.create(:coordinator)
    sign_in(@user.email, @user.password)
    visit_home_page
    visit arrestable_actions_path
    click_on 'Street Swarms'
  end

  scenario 'with 10 participants should save to database' do
    fill_in 'street_swarm_mobilizers_attended', with: '11'
    find('input[name="commit"]').click
    expect(StreetSwarm.last.mobilizers_attended).to eq(11)
  end

  scenario 'with 1 participants should show a success message' do
    fill_in 'street_swarm_mobilizers_attended', with: '1'
    find('input[name="commit"]').click
    expect(page).to have_css '.alert-success'
  end

  scenario 'with -1 participants should not save to database' do
    number_of_records = StreetSwarm.count
    fill_in 'street_swarm_mobilizers_attended', with: '-1'
    find('input[name="commit"]').click
    expect(StreetSwarm.count).to eq(number_of_records)
  end

  scenario 'with -1 participants should show a fail message' do
    fill_in 'street_swarm_mobilizers_attended', with: '-1'
    find('input[name="commit"]').click
    expect(page).to have_css '.alert-danger'
  end

end

feature 'navigation' do

  before(:each) do
    @user = FactoryBot.create(:coordinator)
    sign_in(@user.email, @user.password)
    visit_home_page
    visit arrestable_actions_path
  end

  scenario 'should navigate to forms index when user clicks finish street swarm' do
    click_on 'Back to Report Entry Menu'
    expect(page).to have_current_path forms_index_path, ignore_query: true
  end

  scenario 'should navigate to forms index when user clicks cancel street swarm' do
    click_on 'Street Swarms'
    click_on 'Cancel'
    expect(page).to have_current_path arrestable_actions_path, ignore_query: true
  end

end
