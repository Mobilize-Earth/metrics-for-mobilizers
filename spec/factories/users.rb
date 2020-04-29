FactoryBot.define do
  factory :user do
    first_name {"Name"}
    last_name {"Last"}
    email { "test@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    phone_number {"123456789"}

    factory :coordinator do
      role { "external" }
      chapter
    end

    factory :administrator do
      email { "admin@admin.com" }
      role { "admin" }
    end

    factory :reviewer do
      email { "admin@admin.com" }
      role { "reviewer" }
    end
  end
end
