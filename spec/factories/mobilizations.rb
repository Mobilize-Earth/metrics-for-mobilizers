FactoryBot.define do
  factory :mobilization do
    participants { 1 }
    new_members_sign_ons { 1 }
    total_one_time_donations { 1 }
    xra_donation_suscriptions { 1 }
    arrestable_pledges { 1 }
    xra_newsletter_sign_ups { 1 }
  end
end
