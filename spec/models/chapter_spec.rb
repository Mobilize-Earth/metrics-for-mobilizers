require 'rails_helper'

describe Chapter, type: :model do
  describe "when a new chapter is created" do
    it "should have name, active_members, and total_subscription_amount as required fields" do
      chapter = Chapter.new
      chapter.name = ''
      chapter.active_members = ''
      chapter.total_subscription_amount = ''
      chapter.valid?
      expect(chapter.errors[:name]).to include("can't be blank")
      expect(chapter.errors[:active_members]).to include("can't be blank")
      expect(chapter.errors[:total_subscription_amount]).to include("can't be blank")
    end

    it "should have a unique chapter name" do
      Chapter.create(name: "chapter", active_members: 0, total_subscription_amount: 0.00)
      chapter = Chapter.new
      chapter.name = "chapter"
      chapter.valid?
      expect(chapter.errors[:name]).to include("This Chapter name has already been taken")

      chapter2 = Chapter.new
      chapter.name = "chapter2"
      expect(chapter2.errors[:name]).to be_empty
    end

    describe "when active member is saved" do
      it "should only take numbers" do
        chapter = Chapter.new
        chapter.active_members = 0
        chapter.valid?
        expect(chapter.errors[:active_members]).to be_empty
      end

      it "should throw error if decimal" do
        chapter = Chapter.new
        chapter.active_members = 0.0
        chapter.valid?
        expect(chapter.errors[:active_members]).to include("must be an integer")
      end

      it "should throw error if text" do
        chapter = Chapter.new
        chapter.active_members = "abc"
        chapter.valid?
        expect(chapter.errors[:active_members]).to include("is not a number")
      end
    end
  end
end
