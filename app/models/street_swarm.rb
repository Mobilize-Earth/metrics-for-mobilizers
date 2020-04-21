class StreetSwarm < ApplicationRecord
  belongs_to :user
  belongs_to :chapter

  validates :user, :chapter, presence: true
  validates :xr_members_attended, numericality: {only_integer: true, :greater_than_or_equal_to => 0}
end
