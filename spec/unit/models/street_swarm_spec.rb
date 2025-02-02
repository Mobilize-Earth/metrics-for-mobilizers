require 'rails_helper'

RSpec.describe StreetSwarm, type: :model do
  describe 'when mobilizers_attended is saved' do

    before :each do
      @street_swarm = StreetSwarm.new
    end

    it 'should not take strings' do
      @street_swarm.mobilizers_attended = 'string'
      @street_swarm.valid?
      expect(@street_swarm.errors[:mobilizers_attended]).to include('is not a number')
    end

    it 'should only take positive numbers' do
      @street_swarm.mobilizers_attended = -1
      @street_swarm.valid?
      expect(@street_swarm.errors[:mobilizers_attended]).to include('must be greater than or equal to 1')
    end

    it 'should not take float numbers' do
      @street_swarm.mobilizers_attended = 0.1
      @street_swarm.valid?
      expect(@street_swarm.errors[:mobilizers_attended]).to include('must be an integer')
    end

    it 'should have user, chapter and mobilizers_attended' do
      @street_swarm.valid?
      expect(@street_swarm.errors[:user]).to include('can\'t be blank')
      expect(@street_swarm.errors[:chapter]).to include('can\'t be blank')
    end

    it 'should not take mobilizers_attended greater than 1 billion' do
      @street_swarm.mobilizers_attended = 1000000000+1
      @street_swarm.valid?
      expect(@street_swarm.errors[:mobilizers_attended])
        .to include('must be less than or equal to 1000000000')
    end

    it 'should not take values with length greater than permitted' do
      @street_swarm.identifier = generate_random_string(51)
      @street_swarm.valid?
      expect(@street_swarm.errors[:identifier]).to include('Identifier is too long (maximum is 50 characters)')
    end
  end
end

def generate_random_string(size=1)
  characters = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
  (0...size).map { characters[rand(characters.size)] }.join
end
