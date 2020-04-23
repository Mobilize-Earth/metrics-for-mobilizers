require 'rails_helper'

RSpec.describe ArrestableAction, type: :model do
    describe 'when arrestable_action is saved' do
        before :each do
			@arrestable_action = ArrestableAction.new
		end
		
		it 'should not take strings in numeric fields' do
			@arrestable_action.xra_members = 'string'
			@arrestable_action.xra_not_members = 'string'
			@arrestable_action.trained_arrestable_present = 'string'
			@arrestable_action.arrested = 'string'
			@arrestable_action.days_event_lasted = 'string'
			@arrestable_action.valid?
			expect(@arrestable_action.errors[:xra_members]).to include('is not a number')
			expect(@arrestable_action.errors[:xra_not_members]).to include('is not a number')
			expect(@arrestable_action.errors[:trained_arrestable_present]).to include('is not a number')
			expect(@arrestable_action.errors[:arrested]).to include('is not a number')
			expect(@arrestable_action.errors[:days_event_lasted]).to include('is not a number')
		end

		it 'should not take negative numbers in numeric fields' do
			@arrestable_action.xra_members = -1
			@arrestable_action.xra_not_members = -1
			@arrestable_action.trained_arrestable_present = -1
			@arrestable_action.arrested = -1
			@arrestable_action.days_event_lasted = -1
			@arrestable_action.valid?
			expect(@arrestable_action.errors[:xra_members]).to include('must be greater than or equal to 0')
			expect(@arrestable_action.errors[:xra_not_members]).to include('must be greater than or equal to 0')
			expect(@arrestable_action.errors[:trained_arrestable_present]).to include('must be greater than or equal to 0')
			expect(@arrestable_action.errors[:arrested]).to include('must be greater than or equal to 0')
			expect(@arrestable_action.errors[:days_event_lasted]).to include('must be greater than or equal to 0')
		end

		it 'should not take float in numeric fields' do
			@arrestable_action.xra_members = 0.1
			@arrestable_action.xra_not_members = 0.1
			@arrestable_action.trained_arrestable_present = 0.1
			@arrestable_action.arrested = 0.1
			@arrestable_action.days_event_lasted = 0.1
			@arrestable_action.valid?
			expect(@arrestable_action.errors[:xra_members]).to include('must be an integer')
			expect(@arrestable_action.errors[:xra_not_members]).to include('must be an integer')
			expect(@arrestable_action.errors[:trained_arrestable_present]).to include('must be an integer')
			expect(@arrestable_action.errors[:arrested]).to include('must be an integer')
			expect(@arrestable_action.errors[:days_event_lasted]).to include('must be an integer')
		end

		it 'should not take numeric fields greater than 1 billion' do
			@arrestable_action.xra_members = 1000000000+1
			@arrestable_action.xra_not_members = 1000000000+1
			@arrestable_action.trained_arrestable_present = 1000000000+1
			@arrestable_action.arrested = 1000000000+1
			@arrestable_action.days_event_lasted = 1000000000+1
			@arrestable_action.valid?
			expect(@arrestable_action.errors[:xra_members]).to include('must be less than or equal to 1000000000')
			expect(@arrestable_action.errors[:xra_not_members]).to include('must be less than or equal to 1000000000')
			expect(@arrestable_action.errors[:trained_arrestable_present]).to include('must be less than or equal to 1000000000')
			expect(@arrestable_action.errors[:arrested]).to include('must be less than or equal to 1000000000')
			expect(@arrestable_action.errors[:days_event_lasted]).to include('must be less than or equal to 1000000000')
		end

		it 'should have user, chapter, type' do
			@arrestable_action.valid?
			expect(@arrestable_action.errors[:type_arrestable_action]).to include('can\'t be blank')
			expect(@arrestable_action.errors[:user]).to include('can\'t be blank')
			expect(@arrestable_action.errors[:chapter]).to include('can\'t be blank')
		end
    end
end