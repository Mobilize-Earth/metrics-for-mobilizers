# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_21_222125) do

  create_table "addresses", force: :cascade do |t|
    t.string "country"
    t.string "state_province"
    t.string "city"
    t.string "zip_code"
    t.integer "chapter_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chapter_id"], name: "index_addresses_on_chapter_id"
  end

  create_table "arrestable_actions", force: :cascade do |t|
    t.string "type_arrestable_action"
    t.integer "xra_members", default: 0
    t.integer "xra_not_members", default: 0
    t.integer "trained_arrestable_present", default: 0
    t.integer "arrested", default: 0
    t.integer "days_event_lasted", default: 0
    t.text "report_comment"
    t.integer "chapter_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chapter_id"], name: "index_arrestable_actions_on_chapter_id"
    t.index ["user_id"], name: "index_arrestable_actions_on_user_id"
  end

  create_table "chapters", force: :cascade do |t|
    t.string "name"
    t.integer "active_members"
    t.decimal "total_subscription_amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "street_swarms", force: :cascade do |t|
    t.integer "xr_members_attended", default: 0
    t.integer "chapter_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chapter_id"], name: "index_street_swarms_on_chapter_id"
    t.index ["user_id"], name: "index_street_swarms_on_user_id"
  end

  create_table "trainings", force: :cascade do |t|
    t.integer "number_attendees", default: 0
    t.integer "chapter_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "training_type"
    t.index ["chapter_id"], name: "index_trainings_on_chapter_id"
    t.index ["user_id"], name: "index_trainings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role", default: "reviewer"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.integer "chapter_id"
    t.index ["chapter_id"], name: "index_users_on_chapter_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "chapters"
  add_foreign_key "arrestable_actions", "chapters"
  add_foreign_key "arrestable_actions", "users"
  add_foreign_key "street_swarms", "chapters"
  add_foreign_key "street_swarms", "users"
  add_foreign_key "trainings", "chapters"
  add_foreign_key "trainings", "users"
  add_foreign_key "users", "chapters"
end
