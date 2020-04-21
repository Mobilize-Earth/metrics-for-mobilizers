require 'rails_helper'

RSpec.describe StreetSwarm, type: :model do
  describe 'when xr_members_attended is saved' do

    before :each do
      @street_swarm = StreetSwarm.new
    end

    it 'should not take strings' do
      @street_swarm.xr_members_attended = 'string'
      @street_swarm.valid?
      expect(@street_swarm.errors[:xr_members_attended]).to include('is not a number')
    end

    it 'should only take positive numbers' do
      @street_swarm.xr_members_attended = -1
      @street_swarm.valid?
      expect(@street_swarm.errors[:xr_members_attended]).to include('must be greater than or equal to 0')
    end

    it 'should not take float numbers' do
      @street_swarm.xr_members_attended = 0.1
      @street_swarm.valid?
      expect(@street_swarm.errors[:xr_members_attended]).to include('must be an integer')
    end

    it 'should have user, chapter and xr_members_attended' do
      @street_swarm.valid?
      expect(@street_swarm.errors[:user]).to include('can\'t be blank')
      expect(@street_swarm.errors[:chapter]).to include('can\'t be blank')
    end
  end
end
