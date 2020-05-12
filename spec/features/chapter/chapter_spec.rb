require 'rails_helper'

feature 'create/edit chapter' do
  before(:each) do
    @user = FactoryBot.create(:administrator)
    sign_in(@user.email, @user.password)
    visit_home_page
    find('#chapters-nav-link').click
    find('#link-chapters').click
  end

  scenario 'should throw error if user tries to create chapter with 2,000,000,000 active members' do
    fill_in 'chapter_name', with: 'Chapter Name'
    fill_in 'chapter_total_mobilizers', with: 2000000000
    fill_in 'chapter_total_subscription_amount', with: 100.55
    select 'United States', from: 'chapter_address_attributes_country'
    select 'Alaska', from: 'chapter_address_attributes_state_province'
    select 'Akutan', from: 'chapter_address_attributes_city'
    fill_in 'chapter_address_attributes_zip_code', with: 12345

    find('input[name="commit"]').click
    expect(page).to have_text('Mobilizers total is too long')
  end

  scenario 'should throw error if user tries to create chapter with subscription value greater than 1000000000' do
    fill_in 'chapter_name', with: 'Chapter Name'
    fill_in 'chapter_total_mobilizers', with: 20
    fill_in 'chapter_total_subscription_amount', with: 2000000000.55
    fill_in 'chapter_total_arrestable_pledges', with: 20
    select 'United States', from: 'chapter_address_attributes_country'
    select 'Alaska', from: 'chapter_address_attributes_state_province'
    select 'Akutan', from: 'chapter_address_attributes_city'
    fill_in 'chapter_address_attributes_zip_code', with: 12345

    find('input[name="commit"]').click
    expect(page).to have_text('$ Total of Subscriptions is too long')
  end

  scenario 'should throw error if user tries to create chapter with a name that\'s too long' do
    fill_in 'chapter_name', with: 'fdshsajkdfhkjasdhfkasjdhfkajsdhfkajsdhfkasdfkasjdhfkasjdhfkadhfkasdhfaksadfljsadlfjalsdjflasdjflasdjflasdjflasdjflaskdsffa'
    fill_in 'chapter_total_mobilizers', with: 20
    fill_in 'chapter_total_subscription_amount', with: 200.55
    fill_in 'chapter_total_arrestable_pledges', with: 20
    select 'United States', from: 'chapter_address_attributes_country'
    select 'Alaska', from: 'chapter_address_attributes_state_province'
    select 'Akutan', from: 'chapter_address_attributes_city'
    fill_in 'chapter_address_attributes_zip_code', with: 12345

    find('input[name="commit"]').click
    expect(page).to have_text('Chapter Name is too long')
  end

  scenario 'should save chapter if user tries to create chapter with right values' do
    fill_in 'chapter_name', with: 'Chapter Name'
    fill_in 'chapter_total_mobilizers', with: 20
    fill_in 'chapter_total_subscription_amount', with: 200.55
    fill_in 'chapter_total_arrestable_pledges', with: 20
    select 'United States', from: 'chapter_address_attributes_country'
    select 'Alaska', from: 'chapter_address_attributes_state_province'
    select 'Akutan', from: 'chapter_address_attributes_city'
    fill_in 'chapter_address_attributes_zip_code', with: 12345

    find('input[name="commit"]').click
    expect(page).to have_text('Chapter Name was successfully created!')
    expect(Chapter.last.name).to eq('Chapter Name')
    expect(Chapter.last.total_mobilizers).to eq(20)
    expect(Chapter.last.total_subscription_amount).to eq(200.55)
    expect(Chapter.last.total_arrestable_pledges).to eq(20)
  end
end
