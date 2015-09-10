# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150908151202) do
ActiveRecord::Schema.define(version: 20150909080335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deal_days", force: true do |t|
    t.integer  "deal_id"
    t.boolean  "mon"
    t.boolean  "tue"
    t.boolean  "wed"
    t.boolean  "thur"
    t.boolean  "fri"
    t.boolean  "sat"
    t.boolean  "sun"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deal_times", force: true do |t|
    t.integer  "deal_day_id"
    t.time     "started_at"
    t.time     "ended_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deal_venues", force: true do |t|
    t.integer  "deal_id"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_venues", ["deal_id"], name: "index_deal_venues_on_deal_id", using: :btree
  add_index "deal_venues", ["venue_id"], name: "index_deal_venues_on_venue_id", using: :btree

  create_table "deals", force: true do |t|
    t.string   "title"
    t.boolean  "redeemable"
    t.boolean  "multiple_use"
    t.string   "image"
    t.string   "type_of_deal"
    t.string   "description"
    t.date     "start_date"
    t.date     "expiry_date"
    t.string   "location"
    t.string   "t_c"
    t.integer  "num_of_redeems"
    t.boolean  "pushed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchants", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "merchants", ["email"], name: "index_merchants_on_email", unique: true, using: :btree
  add_index "merchants", ["reset_password_token"], name: "index_merchants_on_reset_password_token", unique: true, using: :btree

  create_table "venues", force: true do |t|
    t.string   "name"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "neighbourhood"
    t.text     "bio"
    t.string   "phone"
    t.boolean  "submitted"
    t.string   "address_2"
    t.string   "contact_number"
    t.string   "contact_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
  end

  add_index "venues", ["merchant_id"], name: "index_venues_on_merchant_id", using: :btree

end
