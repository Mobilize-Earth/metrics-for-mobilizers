require 'rails_helper'

RSpec.describe Training, type: :model do
  describe 'when number_attendees and type are saved' do

    before :each do
      @training = Training.new
    end

    it 'should not take strings' do
      @training.number_attendees = 'string'
      @training.valid?
      expect(@training.errors[:number_attendees]).to include('is not a number')
    end

    it 'should only take positive numbers' do
      @training.number_attendees = -1
      @training.valid?
      expect(@training.errors[:number_attendees]).to include('must be greater than or equal to 0')
    end

    it 'should not take float numbers' do
      @training.number_attendees = 0.1
      @training.valid?
      expect(@training.errors[:number_attendees]).to include('must be an integer')
    end

    it 'should have user, chapter and number_attendees' do
      @training.valid?
      expect(@training.errors[:user]).to include('can\'t be blank')
      expect(@training.errors[:chapter]).to include('can\'t be blank')
      expect(@training.errors[:training_type]).to include('can\'t be blank')
    end
  end
end
