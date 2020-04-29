require 'rails_helper'

RSpec.describe SocialMediaBlitzing, type: :model do
  describe 'when mobilization is saved' do
    before :each do
      @social_media_blitzing = SocialMediaBlitzing.new
    end
    
    it 'should not take string in numeric field' do
      @social_media_blitzing.social_media_campaigns = 'string'
      @social_media_blitzing.valid?
      expect(@social_media_blitzing.errors[:social_media_campaigns]).to include('is not a number')
    end

    it 'should not take negative numbers in numeric field' do
      @social_media_blitzing.social_media_campaigns = 0
      @social_media_blitzing.valid?
      expect(@social_media_blitzing.errors[:social_media_campaigns]).to include('must be greater than 0')
    end

    it 'should not take float numbers in numeric fields' do
      @social_media_blitzing.social_media_campaigns = 0.1
      @social_media_blitzing.valid?
      expect(@social_media_blitzing.errors[:social_media_campaigns]).to include('must be an integer')
    end

    it 'should not take field greater than 1 billion' do
      @social_media_blitzing.social_media_campaigns = 1000000000+1
      @social_media_blitzing.valid?
      expect(@social_media_blitzing.errors[:social_media_campaigns]).to include('must be less than or equal to 1000000000')
    end

    it 'should have user and chapter' do
      @social_media_blitzing.valid?
      expect(@social_media_blitzing.errors[:user]).to include('can\'t be blank')
      expect(@social_media_blitzing.errors[:chapter]).to include('can\'t be blank')
    end
  end
end
