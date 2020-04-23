class Address < ApplicationRecord
  belongs_to :chapter, inverse_of: :address

  validates :country, :state_province, :city, :zip_code, presence: true
end
