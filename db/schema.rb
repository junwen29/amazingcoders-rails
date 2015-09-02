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

ActiveRecord::Schema.define(version: 20150901154955) do

  create_table "deal_hours", force: true do |t|
    t.integer  "deal_id"
    t.string   "day"
    t.time     "started_at"
    t.time     "ended_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deals", force: true do |t|
    t.string   "name_of_deal"
    t.string   "type_of_deal"
    t.string   "description"
    t.date     "start_date"
    t.date     "expiry_date"
    t.boolean  "monday"
    t.time     "monday_start"
    t.time     "monday_end"
    t.boolean  "tuesday"
    t.time     "tuesday_start"
    t.time     "tuesday_end"
    t.boolean  "wednesday"
    t.time     "wednesday_start"
    t.time     "wednesday_end"
    t.boolean  "thursday"
    t.time     "thursday_start"
    t.time     "thursday_end"
    t.boolean  "friday"
    t.time     "friday_start"
    t.time     "friday_end"
    t.boolean  "saturday"
    t.time     "saturday_start"
    t.time     "saturday_end"
    t.boolean  "sunday"
    t.time     "sunday_start"
    t.time     "sunday_end"
    t.string   "location"
    t.string   "t_c"
    t.boolean  "pushed"
    t.boolean  "redeemable"
    t.boolean  "multiple_use"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
