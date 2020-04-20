class Training < ApplicationRecord
  belongs_to :user
  belongs_to :chapter
  belongs_to :training_type

  validates :user, :chapter, :training_type, presence: true
  validates :number_attendees, numericality: {only_integer: true, :greater_than_or_equal_to => 0}
end
