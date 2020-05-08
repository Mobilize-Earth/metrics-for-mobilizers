require 'rails_helper'

RSpec.describe User, type: :model do

  before :each do
    @user = User.new
  end

  describe 'when user is saved' do

    it 'should have email and password' do
      @user.valid?
      expect(@user.errors[:email]).to include('can\'t be blank')
      expect(@user.errors[:password]).to include('can\'t be blank')
    end

    it 'should validate only external role have chapter' do
      @user.role = 'admin'
      @user.chapter_id = 1
      @user.valid?
      expect(@user.errors[:role]).to include('should be external')
    end

    it 'should not validate password when skip password validation is true' do
      @user.skip_password_validation = true
      @user.valid?
      expect(@user.errors[:password]).to_not include('can\'t be blank')
    end

    it 'should validate chapter when role is external' do
      @user.role = 'external'
      @user.valid?
      expect(@user.errors[:chapter]).to include('Chapter must be assigned to External Coordinators')
    end
  end

  describe 'when user is updated' do

    before :each do
      @user.email = 'test_user@test.com'
      @user.skip_password_validation = true
      @user.save
    end

    it 'should not take string in phone number' do
      @user.phone_number = 'string'
      @user.valid?
      expect(@user.errors[:phone_number]).to include('is not a number')
    end

    it 'should not take number smaller than 0 in phone number' do
      @user.phone_number = 0
      @user.valid?
      expect(@user.errors[:phone_number]).to include('must be greater than 0')
    end

    it 'should not take float in phone number' do
      @user.phone_number = 0.1
      @user.valid?
      expect(@user.errors[:phone_number]).to include('must be an integer')
    end

    it 'should validate phone number 000000000' do
      @user.phone_number = '000000000'
      @user.valid?
      expect(@user.errors[:phone_number]).to include('invalid')
    end

    it 'should have first_name last name phone number password and email' do
      @user_last = User.last
      @user_last.valid?
      expect(@user_last.errors[:first_name]).to include('can\'t be blank')
      expect(@user_last.errors[:last_name]).to include('can\'t be blank')
      expect(@user_last.errors[:phone_number]).to include('can\'t be blank')
    end

    it 'should validate that assigned chapter does not have more than two coordinators' do
      # setup
      chapter = FactoryBot.create :chapter
      FactoryBot.create :coordinator, chapter: chapter
      FactoryBot.create :coordinator, chapter: chapter
      chapter.reload
      @user.role = 'external'
      @user.chapter = chapter

      # execute
      @user.valid?

      # assert
      expect(@user.errors[:chapter])
          .to include('Two external coordinators have been already associated with this chapter. A chapter cannot have more than 2 coordinators.')
    end

    it 'the user should be valid when the user is one of the two coordinators assigned' do
      # setup
      chapter = FactoryBot.create :chapter
      FactoryBot.create :coordinator, chapter: chapter
      @user.role = 'external'
      @user.chapter = chapter
      @user.first_name = "charlie"
      @user.last_name = "brown"
      @user.phone_number = "2"
      @user.save
      chapter.reload

      # execute
      is_valid = @user.valid?

      # assert
      expect(is_valid).to be true
    end

  end

  describe 'user aditional functions' do
    it 'should render full name for user with first and last name' do
      @user = User.create({ password: 'admin1', email: 'admin@test.com', role: 'admin', first_name: "Admin", last_name: "Istrator" })

      expect(@user.full_name).to include "Admin Istrator"
    end
  end
end
