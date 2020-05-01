# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

NUMBER_OF_US_CHAPTERS = 5
NUMBER_OF_GLOBAL_CHAPTERS = 5
NUMBER_OF_FORMS_SUBMISSIONS = 5

ArrestableAction.destroy_all
Mobilization.destroy_all
Training.destroy_all
StreetSwarm.destroy_all
Address.destroy_all
User.destroy_all
Chapter.destroy_all

chapter = Chapter.create!(
  name: "Chapter 1", active_members: 10, total_subscription_amount: 100
)
chapter.create_address(country: "United States", state_province: "New York", city: "Flushing", zip_code: "11040")
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

def create_chapters(chapter_id, type)
  state = Faker::Address.state

  chapter = Chapter.create!(
      name: "#{state} Chapter #{chapter_id}",
      active_members: Faker::Number.number(digits: 3),
      total_subscription_amount: Faker::Number.decimal(l_digits: 3, r_digits: 2)
  )

  user = User.create!(
      password: 'external',
      password_confirmation: 'external',
      email: Faker::Internet.email,
      role: 'external',
      first_name: Faker::Name.first_name ,
      last_name: Faker::Name.last_name ,
      phone_number: "8675309",
      chapter: chapter
  )

  Address.create!(
      country: type == 'US' ? 'United States' : Faker::Address.country,
      state_province: state,
      city: Faker::Address.city,
      zip_code: Faker::Address.zip,
      chapter: chapter
  )

  NUMBER_OF_FORMS_SUBMISSIONS.times do |i|
    ArrestableAction.create!(
        type_arrestable_action: 'Local (50+)',
        xra_members: Faker::Number.number(digits: 2),
        xra_not_members: Faker::Number.number(digits: 2),
        trained_arrestable_present: Faker::Number.number(digits: 2),
        arrested: Faker::Number.number(digits: 2),
        chapter: chapter,
        user: user
    )

    participants = Faker::Number.number(digits: 2)
    Mobilization.create!(
        participants: participants,
        new_members_sign_ons: participants / 2,
        xra_donation_suscriptions: Faker::Number.number(digits: 2),
        arrestable_pledges: Faker::Number.number(digits: 2),
        mobilization_type: Mobilization.mobilization_type_options.sample,
        event_type: ['Virtual', 'In Person'].sample,
        total_one_time_donations: Faker::Number.decimal(l_digits: 2, r_digits: 2),
        xra_newsletter_sign_ups: participants / 2,
        chapter: chapter,
        user: user,
        created_at: Faker::Date.between(from: 5.months.ago, to: Date.today).strftime("%Y-%m-%d 07:00:00.00000")
    )

    Training.create!(
        number_attendees: Faker::Number.number(digits: 2),
        chapter: chapter,
        user: user,
        training_type: Training.training_type_options.sample
    )

    StreetSwarm.create!(
        xr_members_attended: Faker::Number.number(digits: 2),
        chapter: chapter,
        user: user
    )
  end
end

NUMBER_OF_US_CHAPTERS.times do |i|
  self.create_chapters(i, 'US')
end


NUMBER_OF_GLOBAL_CHAPTERS.times do |i|
  self.create_chapters(i, 'Global')
end