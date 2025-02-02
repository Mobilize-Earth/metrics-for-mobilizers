FactoryBot.define do
  factory :growth_activity do
    participants { 1 }
    new_mobilizer_sign_ons { Faker::Number.number(digits: 2) }
    total_donation_subscriptions { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    total_one_time_donations { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    donation_subscriptions { 1 }
    arrestable_pledges { Faker::Number.number(digits: 2) }
    newsletter_sign_ups { Faker::Number.number(digits: 2) }
    user { FactoryBot.create(:user) }
    chapter { FactoryBot.create(:chapter, {name: Faker::String.random(length: 15)}) }
    growth_activity_type { GrowthActivity.growth_activity_type_options.sample }
    event_type { ['Virtual', 'In Person'].sample }
    factory :virtual_mobilization do
      event_type { 'Virtual' }
      growth_activity_type {'Rebel Ringing'}
    end
  end
end
