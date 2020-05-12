require 'rails_helper'

feature 'navigation' do
    before(:each) do
        @user = FactoryBot.create(:coordinator)
        sign_in(@user.email, @user.password)
        visit_home_page
        visit growth_activities_path
    end

    scenario 'should access with external role' do
        expect(page).to have_current_path growth_activities_path, ignore_query: true
    end

    scenario 'should navigate to forms index when user clicks back to action' do
        click_on 'Back to forms'
        expect(page).to have_current_path forms_index_path, ignore_query: true
    end

    scenario 'should navigate to moblization page when user clicks cancel' do
        click_on 'Social Media Blitzing'
        click_on 'Cancel'
        expect(page).to have_current_path growth_activities_path, ignore_query: true
    end

    scenario 'should not access with admin role' do
        @admin_user = FactoryBot.create(:administrator)
        find('#dropdown-menu-link').click
        find('#log-out-link').click
        sign_in(@admin_user.email, @admin_user.password)
        visit_home_page
        visit growth_activities_path
        expect(page).to have_current_path admins_index_path, ignore_query: true
        expect(page).to have_css '.alert-danger'
    end
end


feature 'content' do
    before(:each) do
        @user = FactoryBot.create(:coordinator)
        sign_in(@user.email, @user.password)
        visit_home_page
        visit growth_activities_path
    end

    scenario 'should have tabs' do
        expect(page).to have_content "Social Media Blitzing"
    end
end

feature 'submitting social media blitzing' do
    before(:each) do
        @user = FactoryBot.create(:coordinator)
        sign_in(@user.email, @user.password)
        visit_home_page
        visit growth_activities_path
        click_on 'Social Media Blitzing'
    end

    scenario 'should save in database with campaigns, posts, and people posting greater than 0' do
        fill_in 'social_media_blitzing_number_of_posts', with: '10'
        fill_in 'social_media_blitzing_number_of_people_posting', with: '12'
        find('input[name="commit"]').click
        expect(SocialMediaBlitzing.last.number_of_posts).to eq(10)
        expect(SocialMediaBlitzing.last.number_of_people_posting).to eq(12)
    end

    scenario 'should show a success message with campaigns, posts, and people posting greater than 0' do
        fill_in 'social_media_blitzing_number_of_posts', with: '10'
        fill_in 'social_media_blitzing_number_of_people_posting', with: '12'
        find('input[name="commit"]').click
        expect(page).to have_css '.alert-success'
    end

    scenario 'should show a error message without campaigns, posts, or people posting' do
        find('input[name="commit"]').click
        expect(page).to have_css '.alert-danger'
    end

    scenario 'should not save in database if have errors' do
        expected_records = SocialMediaBlitzing.count
        find('input[name="commit"]').click
        actual_records = SocialMediaBlitzing.count
        expect(actual_records).to eq(expected_records)
    end
end