FactoryBot.define do
  factory :user do
    first_name {"Name"}
    last_name {"Last"}
    email { "test@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    phone_number {"123456789"}
    role { "external" }
    chapter

    factory :coordinator do
      first_name {"External"}
      last_name {"Coordinator"}
      email { "external@test.com" }
      password { "password123" }
      password_confirmation { "password123" }
      phone_number {"123456789"}
      role { "external" }
      chapter
    end
  end
end
