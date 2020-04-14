# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#First user
User.create!([
  { password: 'admin1', email: 'admin@test.com', rol: 0 },
  { password: 'external', email: 'external@test.com', rol: 1 },
  { password: 'consumer', email: 'consumer@test.com', rol: 2 }
])