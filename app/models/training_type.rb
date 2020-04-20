class TrainingType < ApplicationRecord
  validates :name, presence: true, uniqueness: { message: "training type name has already been taken", case_sensitive: false }
end
