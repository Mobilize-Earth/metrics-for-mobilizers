require 'rails_helper'

RSpec.describe Mobilization, type: :model do
    describe 'when mobilization is saved' do
        before :each do
			@mobilization = Mobilization.new
        end

        it 'should not take strings in numeric fields' do
            @mobilization.participants = 'string'
            @mobilization.new_members_sign_ons = 'string'
            @mobilization.total_one_time_donations = 'string'
            @mobilization.xra_donation_suscriptions = 'string'
            @mobilization.arrestable_pledges = 'string'
            @mobilization.xra_newsletter_sign_ups = 'string'
            @mobilization.valid?
            expect(@mobilization.errors[:participants]).to include('is not a number')
            expect(@mobilization.errors[:new_members_sign_ons]).to include('is not a number')
            expect(@mobilization.errors[:total_one_time_donations]).to include('is not a number')
            expect(@mobilization.errors[:xra_donation_suscriptions]).to include('is not a number')
            expect(@mobilization.errors[:arrestable_pledges]).to include('is not a number')
            expect(@mobilization.errors[:xra_newsletter_sign_ups]).to include('is not a number')
        end

        it 'should not take negative numbers in numeric fields' do
            @mobilization.participants = -1
            @mobilization.new_members_sign_ons = -1
            @mobilization.total_one_time_donations = -1
            @mobilization.xra_donation_suscriptions = -1
            @mobilization.arrestable_pledges = -1
            @mobilization.xra_newsletter_sign_ups = -1
            @mobilization.valid?
            expect(@mobilization.errors[:participants]).to include('must be greater than or equal to 0')
            expect(@mobilization.errors[:new_members_sign_ons]).to include('must be greater than or equal to 0')
            expect(@mobilization.errors[:total_one_time_donations]).to include('must be greater than or equal to 0')
            expect(@mobilization.errors[:xra_donation_suscriptions]).to include('must be greater than or equal to 0')
            expect(@mobilization.errors[:arrestable_pledges]).to include('must be greater than or equal to 0')
            expect(@mobilization.errors[:xra_newsletter_sign_ups]).to include('must be greater than or equal to 0')
        end

        it 'should not take float numbers in numeric fields' do
            @mobilization.participants = 0.1
            @mobilization.new_members_sign_ons = 0.1
            @mobilization.total_one_time_donations = 0.1
            @mobilization.xra_donation_suscriptions = 0.1
            @mobilization.arrestable_pledges = 0.1
            @mobilization.xra_newsletter_sign_ups = 0.1
            @mobilization.valid?
            expect(@mobilization.errors[:participants]).to include('must be an integer')
            expect(@mobilization.errors[:new_members_sign_ons]).to include('must be an integer')
            expect(@mobilization.errors[:total_one_time_donations]).to include('must be an integer')
            expect(@mobilization.errors[:xra_donation_suscriptions]).to include('must be an integer')
            expect(@mobilization.errors[:arrestable_pledges]).to include('must be an integer')
            expect(@mobilization.errors[:xra_newsletter_sign_ups]).to include('must be an integer')
        end

        it 'should not take fields greater than 1 billion' do
            @mobilization.participants = 1000000000+1
            @mobilization.new_members_sign_ons = 1000000000+1
            @mobilization.total_one_time_donations = 1000000000+1
            @mobilization.xra_donation_suscriptions = 1000000000+1
            @mobilization.arrestable_pledges = 1000000000+1
            @mobilization.xra_newsletter_sign_ups = 1000000000+1
            @mobilization.valid?
            expect(@mobilization.errors[:participants]).to include('must be less than or equal to 1000000000')
            expect(@mobilization.errors[:new_members_sign_ons]).to include('must be less than or equal to 1000000000')
            expect(@mobilization.errors[:total_one_time_donations]).to include('must be less than or equal to 1000000000')
            expect(@mobilization.errors[:xra_donation_suscriptions]).to include('must be less than or equal to 1000000000')
            expect(@mobilization.errors[:arrestable_pledges]).to include('must be less than or equal to 1000000000')
            expect(@mobilization.errors[:xra_newsletter_sign_ups]).to include('must be less than or equal to 1000000000')
        end

        it 'should have user, chapter, type' do
            @mobilization.valid?
            expect(@mobilization.errors[:user]).to include('can\'t be blank')
            expect(@mobilization.errors[:chapter]).to include('can\'t be blank')
            expect(@mobilization.errors[:type_mobilization]).to include('can\'t be blank')
        end
    end
end