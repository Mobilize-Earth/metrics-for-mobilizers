require 'rails_helper'

feature 'submitting training' do

  before(:each) do
    @user = FactoryBot.create(:coordinator)
    sign_in(@user.email, @user.password)
    visit_home_page
    visit trainings_path
  end

  scenario 'should show no form by default' do
    expect(page).to have_content("Form will appear here")
  end

  scenario 'should show form after clicking on option' do
    click_on 'Induction'

    expect(page).not_to have_content("Form will appear here")
  end

  scenario 'should save to database for each valid training type option' do
    count = 1
    Training.training_type_options.each do |option|
      click_on option
      fill_in 'training_number_attendees', with: count
      find('input[name="commit"]').click

      expect(Training.last.number_attendees).to eq(count)
      expect(Training.last.training_type).to eq(option)

      count += 1
    end
  end

  scenario 'with -1 participants should not save to database' do
    number_of_records = Training.count

    click_on 'Induction'
    fill_in 'training_number_attendees', with: -1
    find('input[name="commit"]').click

    expect(Training.count).to eq(number_of_records)
    expect(page).to have_css '.alert-danger'
  end

end

feature 'navigation' do
  before(:each) do
    @user = FactoryBot.create(:coordinator)
    sign_in(@user.email, @user.password)
    visit_home_page
    visit trainings_path
  end

  scenario 'should navigate to forms index when user clicks finish' do
    click_on 'Back to Report Entry Menu'
    expect(page).to have_current_path forms_index_path, ignore_query: true
  end

  scenario 'should navigate to forms index when user clicks cancel' do
    click_on 'Induction'
    click_on 'Cancel'
    expect(page).to have_current_path trainings_path, ignore_query: true
  end

end
