# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Chapter.destroy_all
chapter = Chapter.create!(
  name: "Chapter 1", active_members: 10, total_subscription_amount: 100
)

#First user
User.create!([
  { password: 'external', password_confirmation: 'external', email: 'john@test.com', role: 'external', first_name: "John", last_name: "Smith", phone_number: "1" },
  { password: 'admin1', password_confirmation: 'admin1', email: 'admin@test.com', role: 'admin', first_name: "Admin", last_name: "Istrator", phone_number: "2"  },
  { password: 'external', password_confirmation: 'external', email: 'external@test.com', role: 'external', first_name: "External", last_name: "User", phone_number: "3"  },
  { password: 'consumer', password_confirmation: 'consumer', email: 'consumer@test.com', role: 'consumer', first_name: "Consumer", last_name: "User", phone_number: "4"  }
])
