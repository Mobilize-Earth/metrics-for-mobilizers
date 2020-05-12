require 'rails_helper'

RSpec.describe GrowthActivity, type: :model do
    describe 'when mobilization is saved' do
        before :each do
			@growth_activity = GrowthActivity.new
        end

        it 'should not take strings in numeric fields' do
            @growth_activity.participants = 'string'
            @growth_activity.mobilizers_involved = 'string'
            @growth_activity.new_members_sign_ons = 'string'
            @growth_activity.total_donation_subscriptions = 'string'
            @growth_activity.total_one_time_donations = 'string'
            @growth_activity.donation_subscriptions = 'string'
            @growth_activity.arrestable_pledges = 'string'
            @growth_activity.newsletter_sign_ups = 'string'
            @growth_activity.valid?
            expect(@growth_activity.errors[:participants]).to include("must be a number")
            expect(@growth_activity.errors[:mobilizers_involved]).to include("must be a number")
            expect(@growth_activity.errors[:new_members_sign_ons]).to include("must be a number")
            expect(@growth_activity.errors[:total_donation_subscriptions]).to include("must be a number")
            expect(@growth_activity.errors[:total_one_time_donations]).to include("must be a number")
            expect(@growth_activity.errors[:donation_subscriptions]).to include("must be a number")
            expect(@growth_activity.errors[:arrestable_pledges]).to include("must be a number")
            expect(@growth_activity.errors[:newsletter_sign_ups]).to include("must be a number")
        end

        it 'should not take negative numbers in numeric fields' do
            @growth_activity.participants = -1
            @growth_activity.mobilizers_involved = -1
            @growth_activity.new_members_sign_ons = -1
            @growth_activity.total_donation_subscriptions = -1
            @growth_activity.total_one_time_donations = -1
            @growth_activity.donation_subscriptions = -1
            @growth_activity.arrestable_pledges = -1
            @growth_activity.newsletter_sign_ups = -1
            @growth_activity.valid?
            expect(@growth_activity.errors[:participants]).to include('must be greater than or equal to 0')
            expect(@growth_activity.errors[:mobilizers_involved]).to include('must be greater than or equal to 0')
            expect(@growth_activity.errors[:new_members_sign_ons]).to include('must be greater than or equal to 0')
            expect(@growth_activity.errors[:total_donation_subscriptions]).to include('must be greater than or equal to 0')
            expect(@growth_activity.errors[:total_one_time_donations]).to include('must be greater than or equal to 0')
            expect(@growth_activity.errors[:donation_subscriptions]).to include('must be greater than or equal to 0')
            expect(@growth_activity.errors[:arrestable_pledges]).to include('must be greater than or equal to 0')
            expect(@growth_activity.errors[:newsletter_sign_ups]).to include('must be greater than or equal to 0')
        end

        it 'should not take float numbers in numeric fields' do
            @growth_activity.participants = 0.1
            @growth_activity.mobilizers_involved = 0.1
            @growth_activity.new_members_sign_ons = 0.1
            @growth_activity.donation_subscriptions = 0.1
            @growth_activity.arrestable_pledges = 0.1
            @growth_activity.newsletter_sign_ups = 0.1
            @growth_activity.valid?
            expect(@growth_activity.errors[:participants]).to include('must be a number')
            expect(@growth_activity.errors[:mobilizers_involved]).to include('must be a number')
            expect(@growth_activity.errors[:new_members_sign_ons]).to include('must be a number')
            expect(@growth_activity.errors[:donation_subscriptions]).to include('must be a number')
            expect(@growth_activity.errors[:arrestable_pledges]).to include('must be a number')
            expect(@growth_activity.errors[:newsletter_sign_ups]).to include('must be a number')
        end

        it 'should not take fields greater than 1 billion' do
            @growth_activity.participants = 1000000000+1
            @growth_activity.mobilizers_involved = 1000000000+1
            @growth_activity.new_members_sign_ons = 1000000000+1
            @growth_activity.total_donation_subscriptions = 1000000000+1
            @growth_activity.total_one_time_donations = 1000000000+1
            @growth_activity.donation_subscriptions = 1000000000+1
            @growth_activity.arrestable_pledges = 1000000000+1
            @growth_activity.newsletter_sign_ups = 1000000000+1
            @growth_activity.valid?
            expect(@growth_activity.errors[:participants]).to include('is too big')
            expect(@growth_activity.errors[:mobilizers_involved]).to include('is too big')
            expect(@growth_activity.errors[:new_members_sign_ons]).to include('is too big')
            expect(@growth_activity.errors[:total_donation_subscriptions]).to include('is too big')
            expect(@growth_activity.errors[:total_one_time_donations]).to include('is too big')
            expect(@growth_activity.errors[:donation_subscriptions]).to include('is too big')
            expect(@growth_activity.errors[:arrestable_pledges]).to include('is too big')
            expect(@growth_activity.errors[:newsletter_sign_ups]).to include('is too big')
        end

        it 'should have user, chapter, type' do
            @growth_activity.valid?
            expect(@growth_activity.errors[:user]).to include('can\'t be blank')
            expect(@growth_activity.errors[:chapter]).to include('can\'t be blank')
            expect(@growth_activity.errors[:growth_activity_type]).to include('can\'t be blank')
            expect(@growth_activity.errors[:event_type]).to include('can\'t be blank')
        end
    end
end