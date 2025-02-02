class StreetSwarm < ApplicationRecord
  belongs_to :user
  belongs_to :chapter

  has_one :address, through: :chapter

  scope :with_addresses, -> { includes(:address) }

  def self.options
    ['Street Swarms']
  end

  validates :user, :chapter, presence: true
  validates :mobilizers_attended,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 1_000_000_000 }
  validates_length_of :identifier, maximum: 50

  def self.to_csv
    attributes = %w{chapter_name coordinator_email mobilizers_attended identifier report_date created_at}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.includes(:chapter, :user).find_each do |m|
        csv << [m.chapter.name, m.user.email, m.mobilizers_attended, m.identifier, m.report_date, m.created_at]
      end
    end
  end
end
