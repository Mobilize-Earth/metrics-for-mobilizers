class StreetSwarm < ApplicationRecord
  belongs_to :user
  belongs_to :chapter

  validates :xr_members_attended, numericality: {only_integer: true, :greater_than_or_equal_to => 0}
  validates :user, presence: true
  validates :chapter, presence: true
end
