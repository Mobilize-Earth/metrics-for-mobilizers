FactoryBot.define do
  factory :address do
    zip_code { "12345"}
    factory :us_address do
      country { "United States" }
      state_province { CS.states(:us).values.sample}
    end

    factory :non_us_address do
      country { CS.countries.values.sample }
      state_province { Faker::Address.state }
    end
  end
end