FactoryBot.define do
    factory :user do
      email { "test@example.com" }
      password { "password123" }
      role { "consumer" }
    end
  end
