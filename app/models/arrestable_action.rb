class ArrestableAction < ApplicationRecord
    belongs_to :user
    belongs_to :chapter
    has_one :address, through: :chapter
    scope :with_addresses, -> { includes(:address) }

    def self.options
        ['Street Swarms',
         'Local Arrestable Action',
        'Regional Arrestable Action',
        'National Arrestable Action']
    end

    validates :user,
        :chapter,
        :type_arrestable_action,
        presence: true
    validates :mobilizers,
        :not_mobilizers,
        :trained_arrestable_present,
        :arrested,
        :days_event_lasted,
        numericality: {
            only_integer: true,
            :greater_than_or_equal_to => 0,
            less_than_or_equal_to: 1_000_000_000
        }
    validates_length_of :report_comment, maximum: 2500
    validates_length_of :identifier, maximum: 50

    def self.to_csv
        attributes = %w{chapter_name coordinator_email type_arrestable_action mobilizers not_mobilizers trained_arrestable_present arrested days_event_lasted report_comment identifier report_date created_at}

        CSV.generate(headers: true) do |csv|
            csv << attributes

            all.includes(:chapter, :user).find_each do |m|
                csv << [m.chapter.name, m.user.email, m.type_arrestable_action, m.mobilizers, m.not_mobilizers, m.trained_arrestable_present, m.arrested, m.days_event_lasted, m.report_comment, m.identifier, m.report_date, m.created_at]
            end
        end
    end
end
