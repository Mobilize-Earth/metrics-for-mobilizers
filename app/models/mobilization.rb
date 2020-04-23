class Mobilization < ApplicationRecord
    belongs_to :user
    belongs_to :chapter

    validates :user,
        :chapter,
        :type_mobilization,
        presence: true

    validates :participants,
        :new_members_sign_ons,
        :total_one_time_donations,
        :xra_donation_suscriptions,
        :arrestable_pledges,
        :xra_newsletter_sign_ups,
        numericality:{
            :greater_than_or_equal_to => 0,
            only_integer: true,
            less_than_or_equal_to: 1_000_000_000
        }
end
