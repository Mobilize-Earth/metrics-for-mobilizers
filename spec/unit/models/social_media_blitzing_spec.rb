require 'rails_helper'

RSpec.describe SocialMediaBlitzing, type: :model do
  describe 'when mobilization is saved' do
    before :each do
      @social_media_blitzing = SocialMediaBlitzing.new
    end
    
    it 'should not take string in numeric field' do
      @social_media_blitzing.number_of_posts = 'string'
      @social_media_blitzing.number_of_people_posting = 'string'
      @social_media_blitzing.valid?
      expect(@social_media_blitzing.errors[:number_of_posts]).to include('is not a number')
      expect(@social_media_blitzing.errors[:number_of_people_posting]).to include('is not a number')
    end

    it 'should not take negative numbers in numeric field' do
      @social_media_blitzing.number_of_posts = -1
      @social_media_blitzing.number_of_people_posting = -2
      @social_media_blitzing.valid?
      expect(@social_media_blitzing.errors[:number_of_posts]).to include('must be greater than 0')
      expect(@social_media_blitzing.errors[:number_of_people_posting]).to include('must be greater than 0')
    end

    it 'should not take float numbers in numeric fields' do
      @social_media_blitzing.number_of_posts = 0.5
      @social_media_blitzing.number_of_people_posting = 0.7
      @social_media_blitzing.valid?
      expect(@social_media_blitzing.errors[:number_of_posts]).to include('must be a number')
      expect(@social_media_blitzing.errors[:number_of_people_posting]).to include('must be a number')
    end

    it 'should not take field greater than 1 billion' do
      @social_media_blitzing.number_of_posts = 1000000000+1
      @social_media_blitzing.number_of_people_posting = 1000000000+1
      @social_media_blitzing.valid?
      expect(@social_media_blitzing.errors[:number_of_posts]).to include('is too big')
      expect(@social_media_blitzing.errors[:number_of_people_posting]).to include('is too big')
    end

    it 'should have user and chapter' do
      @social_media_blitzing.valid?
      expect(@social_media_blitzing.errors[:user]).to include('can\'t be blank')
      expect(@social_media_blitzing.errors[:chapter]).to include('can\'t be blank')
    end
  end
end
