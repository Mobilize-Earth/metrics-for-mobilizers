require 'rails_helper'

RSpec.describe Training, type: :model do
  describe 'when saving a Training' do

    before :each do
      @training = Training.new
    end

    it 'should not take strings' do
      @training.number_attendees = 'string'
      @training.valid?
      expect(@training.errors[:number_attendees]).to include('Attendees must be a number')
    end

    it 'should only take positive numbers' do
      @training.number_attendees = -1
      @training.valid?
      expect(@training.errors[:number_attendees]).to include('Attendees must be greater than zero')
    end

    it 'should not take float numbers' do
      @training.number_attendees = 0.1
      @training.valid?
      expect(@training.errors[:number_attendees]).to include('Attendees must be a number')
    end

    it 'should have user, chapter and training_type' do
      @training.valid?
      expect(@training.errors[:user]).to include('can\'t be blank')
      expect(@training.errors[:chapter]).to include('can\'t be blank')
      expect(@training.errors[:training_type]).to include('can\'t be blank')
    end

    it 'should only accept enum values' do
      chapter = Chapter.new
      user = User.new

      @training.chapter = chapter
      @training.user = user
      @training.number_attendees = 7

      Training.training_type_options.each do |type|
        @training.training_type = type
        @training.valid?
        expect(@training.errors[:training_type]).to be_empty
      end

      @training.training_type = 'Garbage'
      @training.valid?
      expect(@training.errors[:training_type]).to include('must be a valid training type')
    end

    it 'should not take number_attendees greater than 1 billion' do
      @training.number_attendees = 1000000000 + 1
      @training.valid?
      expect(@training.errors[:number_attendees])
        .to include('Attendees is too long')
    end

    it 'should not take values with length greater than permitted' do
      @training.identifier = generate_random_string(51)
      @training.valid?
      expect(@training.errors[:identifier]).to include('Identifier is too long (maximum is 50 characters)')
    end
  end
end

def generate_random_string(size=1)
  characters = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
  (0...size).map { characters[rand(characters.size)] }.join
end
