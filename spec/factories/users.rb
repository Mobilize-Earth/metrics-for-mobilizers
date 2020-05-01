FactoryBot.define do
  factory :user do
    first_name {"Name"}
    last_name {"Last"}
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
    phone_number {"123456789"}

    factory :coordinator do
      role { "external" }
      chapter
    end

    factory :administrator do
      role { "admin" }
    end

    factory :reviewer do
      role { "reviewer" }
    end
  end
end
