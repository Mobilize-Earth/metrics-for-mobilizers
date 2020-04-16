class Chapter < ApplicationRecord
  has_many :users

  validates :name, :active_members, :total_subscription_amount, presence: true
  validates :name, uniqueness: { message: "This Chapter name has already been taken", case_sensitive: false }
  validates :active_members, numericality: { only_integer: true }
  validates :total_subscription_amount, numericality: true

  def coordinators
    self.users
  end
end
