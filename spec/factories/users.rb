FactoryBot.define do
    factory :user do
      email { "test@example.com" }
      password { "password123" }
      role { "admin" }
    end
  end
