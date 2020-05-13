class Training < ApplicationRecord
  belongs_to :user
  belongs_to :chapter

  has_one :address, through: :chapter

  scope :with_addresses, -> { includes(:address) }

  def self.training_type_options
    ['Induction',
     'DNA',
     'H4E',
     'NVDA',
     'Facilitation',
     'How to start a new chapter',
     'Mass mobilization',
     'Oppression & Movement Building']
  end

  validates :user, :chapter, presence: true
  validates :number_attendees,
            numericality: { only_integer: true,
                            :greater_than_or_equal_to => 1,
                            less_than_or_equal_to: 1_000_000_000 }
  validates :training_type, presence: true, :inclusion => { message: "must be a valid training type", in: Training.training_type_options }
  validates_length_of :identifier, maximum: 50

  def self.to_csv
    attributes = %w{chapter_name coordinator_email number_attendees training_type identifier report_date created_at}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.includes(:chapter, :user).find_each do |m|
        csv << [m.chapter.name, m.user.email, m.number_attendees, m.training_type, m.identifier, m.report_date, m.created_at]
      end
    end
  end
end
