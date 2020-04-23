class Chapter < ApplicationRecord
  has_many :users
  has_one :address, inverse_of: :chapter, dependent: :destroy

  accepts_nested_attributes_for :address

  validates :name, :active_members, :total_subscription_amount, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates_length_of :name, maximum: 100
  validates :active_members, numericality: { only_integer: true, less_than_or_equal_to: 1_000_000_000 }
  validates :total_subscription_amount, numericality: { less_than_or_equal_to: 1_000_000_000 }

  def coordinators
    self.users
  end
end
