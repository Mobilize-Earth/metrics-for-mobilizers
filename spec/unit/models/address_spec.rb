require 'rails_helper'

describe Address, type: :model do
  describe "when a new address is created" do
    it "should have country and zip code as required fields" do
      address = Address.new
      address.country = ''
      address.zip_code = ''
      address.valid?
      expect(address.errors[:country]).to include("Country is required")
      expect(address.errors[:zip_code]).to include("Zip Code is required")
    end

    it "should have a number for zip code" do
      address = Address.new
      address.zip_code = 'abcd'
      address.valid?
      expect(address.errors[:zip_code]).to include("Zip Code must be a number")
    end

    it "should be an integer for zip code" do
      address = Address.new
      address.zip_code = 0.0
      address.valid?
      expect(address.errors[:zip_code]).to include("Zip Code must be an integer")
    end

    it "should have a maximum of 15 characters for zip code" do
      address = Address.new
      address.zip_code = "1234567891234567"
      address.valid?
      expect(address.errors[:zip_code]).to include("Zip Code is too long")
    end
  end
end
