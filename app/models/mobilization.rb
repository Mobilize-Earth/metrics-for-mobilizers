require 'csv'

class Mobilization < ApplicationRecord
    belongs_to :user
    belongs_to :chapter

    has_one :address, through: :chapter

    scope :with_addresses, -> { includes(:address) }

    def self.mobilization_type_options
        ['H4E Presentations',
        'Rebel Ringing',
        'House Meetings',
        'Fly Posting / Chalking',
        'Door Knocking',
        'Street Stalls',
        'Leafleting','1:1 Recruiting / Other']
    end

    validates :user,
        :chapter,
        :event_type,
        presence: true
    validates :participants,
        :new_members_sign_ons,
        :xra_donation_suscriptions,
        :arrestable_pledges,
        :xra_newsletter_sign_ups,
        numericality:{
            only_integer: true,
            :greater_than_or_equal_to => 0,
            less_than_or_equal_to: 1_000_000_000
        }
    validates :mobilization_type, presence: true, :inclusion => { message: "must be a valid mobilization type", in: Mobilization.mobilization_type_options }
    validates :total_one_time_donations, numericality:{
        :greater_than_or_equal_to => 0,
        less_than_or_equal_to: 1_000_000_000
    }

    def self.to_csv
      attributes = %w{created_at report_date chapter_name coordinator_email mobilization_type event_type participants new_members_sign_ons xra_donation_suscriptions arrestable_pledges xra_newsletter_sign_ups }

      CSV.generate(headers: true) do |csv|
        csv << attributes

        all.includes(:chapter, :user).find_each do |m|
          csv << [ m.created_at, m.report_date, m.chapter.name, m.user.email, m.mobilization_type, m.event_type, m.participants, m.new_members_sign_ons, m.xra_donation_suscriptions, m.arrestable_pledges, m.xra_newsletter_sign_ups ]
        end
      end
    end
end
