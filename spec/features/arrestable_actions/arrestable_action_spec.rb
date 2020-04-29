require 'rails_helper'

feature 'submitting arrestable action' do

    before(:each) do
        @user = FactoryBot.create(:coordinator)
        sign_in(@user.email, @user.password)
        visit_home_page
        visit arrestable_actions_path
        click_on 'National (5000+)'
    end

    scenario 'should save in database with right values' do
        fill_in 'arrestable_action_xra_members', with: '1'
        fill_in 'arrestable_action_xra_not_members', with: '2'
        fill_in 'arrestable_action_trained_arrestable_present', with: '3'
        fill_in 'arrestable_action_arrested', with: '4'
        fill_in 'arrestable_action_days_event_lasted', with: '5'
        fill_in 'arrestable_action_report_comment', with: 'Comment'
        find('input[name="commit"]').click
        expect(ArrestableAction.last.xra_members).to eq(1)
        expect(ArrestableAction.last.xra_not_members).to eq(2)
        expect(ArrestableAction.last.trained_arrestable_present).to eq(3)
        expect(ArrestableAction.last.arrested).to eq(4)
        expect(ArrestableAction.last.days_event_lasted).to eq(5)
        expect(ArrestableAction.last.report_comment).to eq('Comment')
        expect(ArrestableAction.last.type_arrestable_action).to eq('National (5000+)')
    end

    scenario 'should save in database without comment' do
        fill_in 'arrestable_action_xra_members', with: '1'
        fill_in 'arrestable_action_xra_not_members', with: '2'
        fill_in 'arrestable_action_trained_arrestable_present', with: '3'
        fill_in 'arrestable_action_arrested', with: '4'
        fill_in 'arrestable_action_days_event_lasted', with: '5'
        find('input[name="commit"]').click
        expect(ArrestableAction.last.xra_members).to eq(1)
        expect(ArrestableAction.last.xra_not_members).to eq(2)
        expect(ArrestableAction.last.trained_arrestable_present).to eq(3)
        expect(ArrestableAction.last.arrested).to eq(4)
        expect(ArrestableAction.last.days_event_lasted).to eq(5)
        expect(ArrestableAction.last.type_arrestable_action).to eq('National (5000+)')
    end

    scenario 'should show a success message' do
        fill_in 'arrestable_action_xra_members', with: '1'
        fill_in 'arrestable_action_xra_not_members', with: '2'
        fill_in 'arrestable_action_trained_arrestable_present', with: '3'
        fill_in 'arrestable_action_arrested', with: '4'
        fill_in 'arrestable_action_days_event_lasted', with: '5'
        find('input[name="commit"]').click
        expect(page).to have_css '.alert-success'
    end

    scenario 'should show a error message if record has wrong fields' do
        fill_in 'arrestable_action_xra_members', with: '1,1'
        fill_in 'arrestable_action_xra_not_members', with: '2.2'
        fill_in 'arrestable_action_trained_arrestable_present', with: 's'
        fill_in 'arrestable_action_arrested', with: '4.4'
        fill_in 'arrestable_action_days_event_lasted', with: '5-5'
        find('input[name="commit"]').click
        expect(page).to have_css '.alert-danger'
    end

    scenario 'should not save in database if record has wrong fields' do
        expected_records =  ArrestableAction.count
        fill_in 'arrestable_action_xra_members', with: '1,1'
        fill_in 'arrestable_action_xra_not_members', with: '2'
        fill_in 'arrestable_action_trained_arrestable_present', with: '3'
        fill_in 'arrestable_action_arrested', with: '4'
        fill_in 'arrestable_action_days_event_lasted', with: '5'
        find('input[name="commit"]').click
        actual_records = ArrestableAction.count
        expect(actual_records).to eq(expected_records)
    end

end

feature 'navigation' do

    before(:each) do
        @user = FactoryBot.create(:coordinator)
        sign_in(@user.email, @user.password)
        visit_home_page
        visit arrestable_actions_path
    end

    scenario 'should access with external role' do
        expect(page).to have_current_path arrestable_actions_path, ignore_query: true
    end

    scenario 'should navigate to forms index when user clicks back to action' do
        click_on 'Back to forms'
        expect(page).to have_current_path forms_index_path, ignore_query: true
    end

    scenario 'should navigate to arrestable page when user clicks cancel' do
        click_on 'National (5000+)'
        click_on 'Cancel'
        expect(page).to have_current_path arrestable_actions_path, ignore_query: true
    end

    scenario 'should not access with admin role' do
        @admin_user = FactoryBot.create(:administrator)
        find('.logout-button').click
        sign_in(@admin_user.email, @admin_user.password)
        visit_home_page
        visit arrestable_actions_path
        expect(page).to have_current_path admins_index_path, ignore_query: true
        expect(page).to have_css '.alert-danger'
    end
end

feature 'content' do
    before(:each) do
        @user = FactoryBot.create(:coordinator)
        sign_in(@user.email, @user.password)
        visit_home_page
        visit arrestable_actions_path
    end

    scenario 'should have tabs' do
        expect(page).to have_content "Local (50+)"
        expect(page).to have_content "Regional (500+)"
        expect(page).to have_content "National (5000+)"
    end
end
