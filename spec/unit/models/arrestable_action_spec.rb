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
			expect(@arrestable_action.errors[:xra_members][0]).to include('must be a number')
			expect(@arrestable_action.errors[:xra_not_members][0]).to include('must be a number')
			expect(@arrestable_action.errors[:trained_arrestable_present][0]).to include('must be a number')
			expect(@arrestable_action.errors[:arrested][0]).to include('must be a number')
			expect(@arrestable_action.errors[:days_event_lasted][0]).to include('must be a number')
		end

		it 'should not take negative numbers in numeric fields' do
			@arrestable_action.xra_members = -1
			@arrestable_action.xra_not_members = -1
			@arrestable_action.trained_arrestable_present = -1
			@arrestable_action.arrested = -1
			@arrestable_action.days_event_lasted = -1
			@arrestable_action.valid?
			expect(@arrestable_action.errors[:xra_members][0]).to include('must be greater than or equal to zero')
			expect(@arrestable_action.errors[:xra_not_members][0]).to include('must be greater than or equal to zero')
			expect(@arrestable_action.errors[:trained_arrestable_present][0]).to include('must be greater than or equal to zero')
			expect(@arrestable_action.errors[:arrested][0]).to include('must be greater than or equal to zero')
			expect(@arrestable_action.errors[:days_event_lasted][0]).to include('must be greater than or equal to zero')
		end

		it 'should not take float in numeric fields' do
			@arrestable_action.xra_members = 0.1
			@arrestable_action.xra_not_members = 0.1
			@arrestable_action.trained_arrestable_present = 0.1
			@arrestable_action.arrested = 0.1
			@arrestable_action.days_event_lasted = 0.1
			@arrestable_action.valid?
			expect(@arrestable_action.errors[:xra_members][0]).to include("must be an integer")
			expect(@arrestable_action.errors[:xra_not_members][0]).to include('must be an integer')
			expect(@arrestable_action.errors[:trained_arrestable_present][0]).to include('must be an integer')
			expect(@arrestable_action.errors[:arrested][0]).to include('must be an integer')
			expect(@arrestable_action.errors[:days_event_lasted][0]).to include('must be an integer')
		end

		it 'should not take numeric fields greater than 1 billion' do
			@arrestable_action.xra_members = 1000000000+1
			@arrestable_action.xra_not_members = 1000000000+1
			@arrestable_action.trained_arrestable_present = 1000000000+1
			@arrestable_action.arrested = 1000000000+1
			@arrestable_action.days_event_lasted = 1000000000+1
			@arrestable_action.valid?
			expect(@arrestable_action.errors[:xra_members][0]).to include('is too long')
			expect(@arrestable_action.errors[:xra_not_members][0]).to include('is too long')
			expect(@arrestable_action.errors[:trained_arrestable_present][0]).to include('is too long')
			expect(@arrestable_action.errors[:arrested][0]).to include('is too long')
			expect(@arrestable_action.errors[:days_event_lasted][0]).to include('is too long')
		end

		it 'should not take values with length greater than permitted' do
			@arrestable_action.report_comment = generate_random_string(2501)
			@arrestable_action.valid?
			expect(@arrestable_action.errors[:report_comment]).to include('is too long (maximum is 2500 characters)')
		end

		it 'should have user, chapter, type' do
			@arrestable_action.valid?
			expect(@arrestable_action.errors[:type_arrestable_action]).to include('can\'t be blank')
			expect(@arrestable_action.errors[:user]).to include('can\'t be blank')
			expect(@arrestable_action.errors[:chapter]).to include('can\'t be blank')
		end
    end
end

def generate_random_string(size=1)
	characters = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
	string = (0...size).map { characters[rand(characters.size)] }.join
end