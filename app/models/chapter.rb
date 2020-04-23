class Chapter < ApplicationRecord
  has_many :users

  validates :name, :active_members, :total_subscription_amount, presence: true
  validates :name, uniqueness: { message: "of this chapter has already been taken", case_sensitive: false }
  validates :active_members, numericality: { only_integer: true }
  validates :total_subscription_amount, numericality: true

  def coordinators
    self.users
  end

  # Only for location spike:
  # Simulation of Country, State codes
  # and City Name

  def country_code
    ["CO", "US", "EC", "GB"].sample #random
  end

  def country_array
    [country_code, CS.countries[country_code.to_sym]]
  end
end
