require 'csv'

class GrowthActivity < ApplicationRecord
    belongs_to :user
    belongs_to :chapter

    has_one :address, through: :chapter

    scope :with_addresses, -> { includes(:address) }

    def self.growth_activity_type_options
        ['H4E Presentations',
        'Rebel Ringing',
        'House Meetings',
        'Fly Posting / Chalking',
        'Door Knocking',
        'Street Stalls',
        'Leafleting',
         '1:1 Recruiting / Other']
    end

    validates :user,
        :chapter,
        :event_type,
        presence: true
    validates :participants,
        :mobilizers_involved,
        :new_mobilizer_sign_ons,
        :donation_subscriptions,
        :arrestable_pledges,
        :newsletter_sign_ups,
        numericality: {
            only_integer: true,
            :greater_than_or_equal_to => 0,
            less_than_or_equal_to: 1_000_000_000
        }
    validates :growth_activity_type, presence: true, :inclusion => { message: "must be a valid mobilization type", in: GrowthActivity.growth_activity_type_options }
    validates :total_one_time_donations,
              :total_donation_subscriptions,
              numericality: {
                  :greater_than_or_equal_to => 0,
                  less_than_or_equal_to: 1_000_000_000
    }
    validates_length_of :identifier, maximum: 50

    def self.to_csv
      attributes = %w{chapter_name coordinator_email growth_activity_type event_type participants mobilizers_involved new_mobilizer_sign_ons total_donation_subscriptions donation_subscriptions total_one_time_donations arrestable_pledges newsletter_sign_ups identifier report_date created_at}

      CSV.generate(headers: true) do |csv|
        csv << attributes

        all.includes(:chapter, :user).find_each do |m|
          csv << [m.chapter.name, m.user.email, m.growth_activity_type, m.event_type, m.participants, m.mobilizers_involved, m.new_mobilizer_sign_ons, "$#{m.total_donation_subscriptions}", m.donation_subscriptions, "$#{m.total_one_time_donations}", m.arrestable_pledges, m.newsletter_sign_ups, m.identifier, m.report_date, m.created_at]
        end
      end
    end
end
