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

ActiveRecord::Schema.define(version: 20150905110649) do

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
    t.string   "qrCodeLink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_venues", ["deal_id"], name: "index_deal_venues_on_deal_id", using: :btree
  add_index "deal_venues", ["venue_id"], name: "index_deal_venues_on_venue_id", using: :btree

  create_table "deals", force: true do |t|
    t.string   "name_of_deal"
    t.string   "type_of_deal"
    t.string   "description"
    t.date     "start_date"
    t.date     "expiry_date"
    t.string   "location"
    t.string   "t_c"
    t.boolean  "pushed"
    t.boolean  "redeemable"
    t.boolean  "multiple_use"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venue_deals", force: true do |t|
    t.integer  "deals_id"
    t.integer  "venues_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venue_deals", ["deals_id"], name: "index_venue_deals_on_deals_id", using: :btree
  add_index "venue_deals", ["venues_id"], name: "index_venue_deals_on_venues_id", using: :btree

  create_table "venues", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
  end

end
