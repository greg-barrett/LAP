# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181016095456) do

  create_table "reservations", force: :cascade do |t|
    t.date "arrival_date"
    t.date "departure_date"
    t.boolean "confirmed"
    t.float "fee"
    t.integer "party_size"
    t.text "notes"
    t.integer "reserver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["arrival_date"], name: "index_reservations_on_arrival_date", unique: true
    t.index ["departure_date"], name: "index_reservations_on_departure_date", unique: true
    t.index ["reserver_id"], name: "index_reservations_on_reserver_id"
  end

  create_table "reservers", force: :cascade do |t|
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.string "id_type"
    t.string "id_number"
    t.string "contact_number"
    t.string "email_address"
    t.string "house_number"
    t.string "street_name"
    t.string "city"
    t.string "country"
    t.string "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_reservers_on_email_address"
    t.index ["last_name"], name: "index_reservers_on_last_name"
  end

end
