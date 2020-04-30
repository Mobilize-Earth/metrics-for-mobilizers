require 'rails_helper'

feature 'navigation' do
    before(:each) do
        @user = FactoryBot.create(:coordinator)
        sign_in(@user.email, @user.password)
        visit_home_page
        visit mobilizations_path
    end

    scenario 'should access with external role' do
        expect(page).to have_current_path mobilizations_path, ignore_query: true
    end

    scenario 'should navigate to forms index when user clicks back to forms action' do
        click_on 'Back to forms'
        expect(page).to have_current_path forms_index_path, ignore_query: true
    end

    scenario 'should navigate to mobilization page when clicks cancel' do
        click_on 'Leafleting'
        click_on 'Cancel'
        expect(page).to have_current_path mobilizations_path, ignore_query: true
    end

    scenario 'should not access with admin role' do
        @admin_user = FactoryBot.create(:administrator)
        find('#dropdown-menu-link').click
        find('#log-out-link').click
        sign_in(@admin_user.email, @admin_user.password)
        visit_home_page
        visit mobilizations_path
        expect(page).to have_current_path admins_index_path, ignore_query: true
        expect(page).to have_css '.alert-danger'
    end
end

feature 'content' do
    before(:each) do
        @user = FactoryBot.create(:coordinator)
        sign_in(@user.email, @user.password)
        visit_home_page
        visit mobilizations_path
    end

    scenario 'should have tabs' do
        expect(page).to have_content "H4E Presentations"
        expect(page).to have_content "Rebel Ringing"
        expect(page).to have_content "House Meetings"
        expect(page).to have_content "Fly Posting / Chalking"
        expect(page).to have_content "Door Knocking"
        expect(page).to have_content "Street Stalls"
        expect(page).to have_content "Leafleting"
        expect(page).to have_content "1:1 Recruiting / Other"
    end
end

feature 'submitting mobilization' do
    before(:each) do
        @user = FactoryBot.create(:coordinator)
        sign_in(@user.email, @user.password)
        visit_home_page
        visit mobilizations_path
        click_on 'House Meetings'
    end

    scenario 'should save in database with right values' do
        choose('mobilization_event_type_in_person')
        fill_in 'mobilization_participants', with: '1'
        fill_in 'mobilization_new_members_sign_ons', with: '2'
        fill_in 'mobilization_total_one_time_donations', with: '3.25'
        fill_in 'mobilization_xra_donation_suscriptions', with: '4'
        fill_in 'mobilization_arrestable_pledges', with: '5'
        fill_in 'mobilization_xra_newsletter_sign_ups', with: '6'
        find('input[name="commit"]').click
        expect(Mobilization.last.event_type).to eq('in_person')
        expect(Mobilization.last.mobilization_type).to eq('House Meetings')
        expect(Mobilization.last.participants).to eq(1)
        expect(Mobilization.last.new_members_sign_ons).to eq(2)
        expect(Mobilization.last.total_one_time_donations).to eq(3.25)
        expect(Mobilization.last.xra_donation_suscriptions).to eq(4)
        expect(Mobilization.last.arrestable_pledges).to eq(5)
        expect(Mobilization.last.xra_newsletter_sign_ups).to eq(6)
    end

    scenario 'should show a success message' do
        choose('mobilization_event_type_virtual')
        fill_in 'mobilization_participants', with: '1'
        fill_in 'mobilization_new_members_sign_ons', with: '2'
        fill_in 'mobilization_total_one_time_donations', with: '3'
        fill_in 'mobilization_xra_donation_suscriptions', with: '4'
        fill_in 'mobilization_arrestable_pledges', with: '5'
        fill_in 'mobilization_xra_newsletter_sign_ups', with: '6'
        find('input[name="commit"]').click
        expect(page).to have_css '.alert-success'
    end

    scenario 'should show a error message' do
        choose('mobilization_event_type_virtual')
        fill_in 'mobilization_participants', with: '1,1'
        fill_in 'mobilization_new_members_sign_ons', with: 's'
        fill_in 'mobilization_total_one_time_donations', with: '3'
        fill_in 'mobilization_xra_donation_suscriptions', with: '4'
        fill_in 'mobilization_arrestable_pledges', with: '5'
        fill_in 'mobilization_xra_newsletter_sign_ups', with: '6'
        find('input[name="commit"]').click
        expect(page).to have_css '.alert-danger'
    end

    scenario 'should show not save in database if record has wrong fields' do
        expected_records = Mobilization.count
        choose('mobilization_event_type_virtual')
        fill_in 'mobilization_participants', with: '1,1'
        fill_in 'mobilization_new_members_sign_ons', with: 's'
        fill_in 'mobilization_total_one_time_donations', with: '3'
        fill_in 'mobilization_xra_donation_suscriptions', with: '4'
        fill_in 'mobilization_arrestable_pledges', with: '5'
        fill_in 'mobilization_xra_newsletter_sign_ups', with: '6'
        find('input[name="commit"]').click
        actual_records = Mobilization.count
        expect(actual_records).to eq(expected_records)
    end

    scenario 'should update active number in chapters when mobilization is reported' do
        random_new_members = rand(20)
        expected_chapter_members = Chapter.last.active_members + random_new_members
        choose('mobilization_event_type_in_person')
        fill_in 'mobilization_participants', with: '1'
        fill_in 'mobilization_new_members_sign_ons', with: random_new_members
        fill_in 'mobilization_total_one_time_donations', with: '3.25'
        fill_in 'mobilization_xra_donation_suscriptions', with: '4'
        fill_in 'mobilization_arrestable_pledges', with: '5'
        fill_in 'mobilization_xra_newsletter_sign_ups', with: '6'
        find('input[name="commit"]').click
        expect(Chapter.last.active_members).to eq(expected_chapter_members)
    end
end