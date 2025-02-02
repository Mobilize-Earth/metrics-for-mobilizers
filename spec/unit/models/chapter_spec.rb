require 'rails_helper'

describe Chapter, type: :model do
  describe "when a new chapter is created" do
    it "should have name, total_mobilizers, and total_subscription_amount as required fields" do
      chapter = Chapter.new
      chapter.name = ''
      chapter.total_mobilizers = ''
      chapter.total_subscription_amount = ''
      chapter.valid?
      expect(chapter.errors[:name]).to include("Chapter Name is required")
      expect(chapter.errors[:total_mobilizers]).to include("Mobilizers total is required")
      expect(chapter.errors[:total_subscription_amount]).to include("$ Total of Subscriptions is required")
    end

    it "should have a unique chapter name" do
      Chapter.create(name: "chapter", total_mobilizers: 10, total_subscription_amount: 100, total_arrestable_pledges: 100)
      chapter = Chapter.new
      chapter.name = "chapter"
      chapter.valid?
      expect(chapter.errors[:name]).to include("Chapter Name is already taken")

      chapter2 = Chapter.new
      chapter.name = "chapter2"
      expect(chapter2.errors[:name]).to be_empty
    end

    it "should not save if active members is greater than 1,000,000,000" do
      chapter = Chapter.create(name: "chapter 45", total_mobilizers: 2_000_000_000, total_subscription_amount: 0.00, total_arrestable_pledges: 100)
      chapter.valid?
      expect(chapter.errors[:total_mobilizers]).to include("Mobilizers total is too long")
    end

    it "should not save if total arrestable pledges is greater than 1,000,000,000" do
      chapter = Chapter.create(name: "chapter 45", total_mobilizers: 100, total_subscription_amount: 0.00, total_arrestable_pledges: 2_000_000_000)
      chapter.valid?
      expect(chapter.errors[:total_arrestable_pledges]).to include("Arrestable Pledges total is too long")
    end

    it "should not save if total subscription amount is greater than 1,000,000,000" do
      chapter = Chapter.create(name: "chapter 45", total_mobilizers: 10, total_subscription_amount: 2_000_000_000)
      chapter.valid?
      expect(chapter.errors[:total_subscription_amount]).to include("$ Total of Subscriptions is too long")
    end

    it "should not save if total chapter title is greater than 100 characters" do
      chapter = Chapter.create(name: "fdshsajkdfhkjasdhfkasjdhfkajsdhfkajsdhfkasdfkasjdhfkasjdhfka
                                      dhfkasdhfaksadfljsadlfjalsdjflasdjflasdjflasdjflasdjflaskdsffah",
                               total_mobilizers: 10,
                               total_subscription_amount: 2_000_000_000,
                               total_arrestable_pledges: 100)
      chapter.valid?
      expect(chapter.errors[:name]).to include("Chapter Name is too long")
    end
  end

  describe "when active member is saved" do
      it "should only take numbers" do
        chapter = Chapter.new
        chapter.total_mobilizers = 0
        chapter.valid?
        expect(chapter.errors[:total_mobilizers]).to be_empty
      end

      it "should throw error if decimal" do
        chapter = Chapter.new
        chapter.total_mobilizers = 0.0
        chapter.valid?
        expect(chapter.errors[:total_mobilizers]).to include("Mobilizers total must be a number")
      end

      it "should throw error if text" do
        chapter = Chapter.new
        chapter.total_mobilizers = "abc"
        chapter.valid?
        expect(chapter.errors[:total_mobilizers]).to include("Mobilizers total must be a number")
      end
  end

  describe "has address" do
    it "should return true if chapter has an address" do
      chapter = Chapter.create(name: 'New Chapter', total_mobilizers: 10, total_subscription_amount: 1000, total_arrestable_pledges: 100)
      address = Address.create(country: 'United State', state_province: 'Kansas', zip_code: '12456')
      chapter.address = address
      chapter.save
      expect(chapter.has_address?).to be(true)
    end
  end
end
