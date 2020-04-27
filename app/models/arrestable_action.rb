class ArrestableAction < ApplicationRecord
    belongs_to :user
    belongs_to :chapter

    def self.options
        ['Local (50+)',
        'Regional (500+)',
        'National (5000+)']
    end

    validates :user,
        :chapter,
        :type_arrestable_action,
        presence: true
    validates :xra_members,
        :xra_not_members,
        :trained_arrestable_present,
        :arrested,
        :days_event_lasted,
        numericality: {
            only_integer: true,
            :greater_than_or_equal_to => 0,
            less_than_or_equal_to: 1_000_000_000
        }
    validates_length_of :report_comment, maximum: 2500
end
