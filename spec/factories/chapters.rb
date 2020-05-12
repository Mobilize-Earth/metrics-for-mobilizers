FactoryBot.define do
    factory :chapter do
      name { "Climate Change Renegades Chapter" }
      total_mobilizers { Faker::Number.number(digits: 2) }
      total_subscription_amount { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
      total_arrestable_pledges { Faker::Number.number(digits: 2) }
    end
  end
