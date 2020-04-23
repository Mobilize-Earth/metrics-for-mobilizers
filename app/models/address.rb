class Address < ApplicationRecord
  belongs_to :chapter, inverse_of: :address

  validates :country, :zip_code, presence: true
  validates :zip_code, numericality: { only_integer: true }
  validates :zip_code, length: { maximum: 15 }
end
