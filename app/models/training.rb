class Training < ApplicationRecord
  belongs_to :user
  belongs_to :chapter

  validates :user, :chapter, presence: true
  validates :number_attendees, numericality: {only_integer: true, :greater_than_or_equal_to => 0}
  validates :training_type, presence: true
end
