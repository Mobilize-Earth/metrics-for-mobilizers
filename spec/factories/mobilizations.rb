FactoryBot.define do
  factory :mobilization do
    participants { 1 }
    new_members_sign_ons { 1 }
    total_one_time_donations { 1 }
    xra_donation_suscriptions { 1 }
    arrestable_pledges { 1 }
    xra_newsletter_sign_ups { 1 }
    user { FactoryBot.create(:user) }
    chapter { FactoryBot.create(:chapter, {name: Faker::String.random(length: 15)}) }
    mobilization_type { Mobilization.mobilization_type_options.sample }
    event_type { ['Virtual', 'In Person'].sample }
    factory :virtual_mobilization do
      event_type { 'Virtual' }
      mobilization_type {'Rebel Ringing'}
    end
  end
end
