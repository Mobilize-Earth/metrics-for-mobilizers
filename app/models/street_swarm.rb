class StreetSwarm < ApplicationRecord
  belongs_to :user
  belongs_to :chapter

  has_one :address, through: :chapter

  scope :with_addresses, -> { includes(:address) }

  def self.options
    ['Street Swarms']
  end

  validates :user, :chapter, presence: true
  validates :xr_members_attended,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 1_000_000_000 }
end
