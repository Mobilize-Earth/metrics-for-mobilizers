class Chapter < ApplicationRecord
  has_many :users
  has_one :address, inverse_of: :chapter, dependent: :destroy
  has_many :trainings
  has_many :mobilizations
  has_many :street_swarms
  has_many :arrestable_actions

  accepts_nested_attributes_for :address

  validates :name, :active_members, :total_subscription_amount, :total_arrestable_pledges, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates_length_of :name, maximum: 100
  validates :active_members, numericality: { only_integer: true, less_than_or_equal_to: 1_000_000_000 }
  validates :total_subscription_amount, numericality: { less_than_or_equal_to: 1_000_000_000 }
  validates :total_arrestable_pledges, numericality: { only_integer: true, less_than_or_equal_to: 1_000_000_000 }

  scope :with_addresses, -> { includes(:address) }

  scope :all_relationships, -> { includes(:address, :trainings, :mobilizations, :street_swarms, :arrestable_actions) }

  def coordinators
    self.users
  end

  def has_address?
    true unless self.address.nil?
  end
end
