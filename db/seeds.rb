# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

NUMBER_OF_CHAPTERS = 5

User.destroy_all
Chapter.destroy_all
chapter = Chapter.create!(
  name: "Chapter 1", active_members: 10, total_subscription_amount: 100
)
chapter.create_address(country: "US", state_province: "NY", city: "Flushing", zip_code: "11040")
#Admin and Consumer without chapters
User.create!([
  { password: 'admin1', password_confirmation: 'admin1', email: 'admin@test.com', role: 'admin', first_name: "Admin", last_name: "Istrator", phone_number: "2"  },
  { password: 'reviewer', password_confirmation: 'reviewer', email: 'reviewer@test.com', role: 'reviewer', first_name: "Reviewer", last_name: "User", phone_number: "4"  }
])

#External coordinators with chapters
chapter.users.create!([
  { password: 'external', password_confirmation: 'external', email: 'external@test.com', role: 'external', first_name: "External", last_name: "User", phone_number: "3" },
  { password: 'external', password_confirmation: 'external', email: 'john@test.com', role: 'external', first_name: "John", last_name: "Smith", phone_number: "1" }
])

NUMBER_OF_CHAPTERS.times do |i|
    state = Faker::Address.state

    chapter = Chapter.create!(
        name: "#{state} Chapter #{i}",
        active_members: Faker::Number.number(digits: 3),
        total_subscription_amount: Faker::Number.decimal(l_digits: 3, r_digits: 2)
    )

    Address.create!(
        country: 'United States',
        state_province: state,
        city: Faker::Address.city,
        zip_code: Faker::Address.zip,
        chapter: chapter
    )
end
