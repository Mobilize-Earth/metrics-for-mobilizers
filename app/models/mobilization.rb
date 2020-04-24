class Mobilization < ApplicationRecord

    def self.options
        ['H4E Presentations',
        'Rebel Ringing',
        'House Meetings',
        'Fly Posting / Chalking',
        'Door Knocking',
        'Street Stalls',
        'Leafleting','1:1 Recruiting / Other']
    end

    belongs_to :user
    belongs_to :chapter

    validates :user,
        :chapter,
        :mobilization_type,
        :event_type,
        presence: true

    validates :participants,
        :new_members_sign_ons,
        :total_one_time_donations,
        :xra_donation_suscriptions,
        :arrestable_pledges,
        :xra_newsletter_sign_ups,
        numericality:{
            only_integer: true,
            :greater_than_or_equal_to => 0,
            less_than_or_equal_to: 1_000_000_000
        }
end
