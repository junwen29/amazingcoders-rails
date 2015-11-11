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

ActiveRecord::Schema.define(version: 20151110041018) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "add_on_payments", force: true do |t|
    t.integer  "add_on_id"
    t.integer  "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "add_on_payments", ["add_on_id"], name: "index_add_on_payments_on_add_on_id", using: :btree
  add_index "add_on_payments", ["payment_id"], name: "index_add_on_payments_on_payment_id", using: :btree

  create_table "add_ons", force: true do |t|
    t.integer  "payment_id"
    t.integer  "plan_id"
    t.string   "name"
    t.decimal  "cost",        precision: 8, scale: 2
    t.string   "description"
    t.string   "addon_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "add_ons", ["payment_id"], name: "index_add_ons_on_payment_id", using: :btree
  add_index "add_ons", ["plan_id"], name: "index_add_ons_on_plan_id", using: :btree

  create_table "admin_users", force: true do |t|
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

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "attachinary_files", force: true do |t|
    t.integer  "attachinariable_id"
    t.string   "attachinariable_type"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachinary_files", ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree

  create_table "bookmarks", force: true do |t|
    t.integer  "user_id"
    t.integer  "deal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charges", force: true do |t|
  end

  create_table "deal_analytics", force: true do |t|
    t.integer  "deal_id"
    t.integer  "view_count",        default: 0
    t.integer  "unique_view_count", default: 0
    t.integer  "redemption_count",  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deal_analytics", ["deal_id"], name: "index_deal_analytics_on_deal_id", using: :btree

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
    t.string   "type_of_deal"
    t.text     "description"
    t.date     "start_date"
    t.date     "expiry_date"
    t.string   "location"
    t.text     "t_c"
    t.boolean  "pushed",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "active",             default: false
    t.integer  "num_of_redeems",     default: 0
    t.datetime "activate_date"
    t.datetime "push_date"
  end

  add_index "deals", ["merchant_id"], name: "index_deals_on_merchant_id", using: :btree

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.string   "device_type"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gifts", force: true do |t|
    t.string   "name"
    t.integer  "points"
    t.string   "description"
    t.string   "gift_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchant_feedbacks", force: true do |t|
    t.string   "title"
    t.string   "category"
    t.text     "content"
    t.boolean  "resolved",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
  end

  add_index "merchant_feedbacks", ["merchant_id"], name: "index_merchant_feedbacks_on_merchant_id", using: :btree

  create_table "merchant_points", force: true do |t|
    t.string   "reason"
    t.integer  "points"
    t.string   "operation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
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
    t.integer  "total_points",           default: 0
  end

  add_index "merchants", ["email"], name: "index_merchants_on_email", unique: true, using: :btree
  add_index "merchants", ["reset_password_token"], name: "index_merchants_on_reset_password_token", unique: true, using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.string   "item_type"
    t.integer  "item_id"
    t.string   "item_name"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.date     "start_date"
    t.date     "expiry_date"
    t.decimal  "total_cost",  precision: 8, scale: 2
    t.boolean  "add_on1"
    t.boolean  "add_on2"
    t.boolean  "add_on3"
    t.boolean  "plan1"
    t.boolean  "paid",                                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
    t.integer  "months"
  end

  add_index "payments", ["merchant_id"], name: "index_payments_on_merchant_id", using: :btree

  create_table "plan_payments", force: true do |t|
    t.integer  "plan_id"
    t.integer  "payment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plan_payments", ["payment_id"], name: "index_plan_payments_on_payment_id", using: :btree
  add_index "plan_payments", ["plan_id"], name: "index_plan_payments_on_plan_id", using: :btree

  create_table "plans", force: true do |t|
    t.integer  "payment_id"
    t.string   "name"
    t.decimal  "cost",        precision: 8, scale: 2
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["payment_id"], name: "index_plans_on_payment_id", using: :btree

  create_table "redemptions", force: true do |t|
    t.integer  "deal_id"
    t.integer  "user_id"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_point_id"
  end

  add_index "redemptions", ["deal_id"], name: "index_redemptions_on_deal_id", using: :btree
  add_index "redemptions", ["user_id"], name: "index_redemptions_on_user_id", using: :btree

  create_table "user_feedbacks", force: true do |t|
    t.string   "title"
    t.string   "category"
    t.text     "content"
    t.boolean  "resolved",   default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_feedbacks", ["user_id"], name: "index_user_feedbacks_on_user_id", using: :btree

  create_table "user_points", force: true do |t|
    t.string   "reason"
    t.integer  "points"
    t.string   "operation"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_points", ["user_id"], name: "index_user_points_on_user_id", using: :btree

  create_table "user_queries", force: true do |t|
    t.string   "query"
    t.integer  "num_count"
    t.string   "query_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
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
    t.string   "authentication_token"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "total_points",           default: 0
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "venues", force: true do |t|
    t.string   "name"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city",               default: "Singapore"
    t.string   "state",              default: "Singapore"
    t.string   "country",            default: "Singapore"
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
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "venues", ["merchant_id"], name: "index_venues_on_merchant_id", using: :btree

  create_table "viewcounts", force: true do |t|
    t.integer  "deal_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "entry"
  end

  add_index "viewcounts", ["deal_id"], name: "index_viewcounts_on_deal_id", using: :btree
  add_index "viewcounts", ["user_id"], name: "index_viewcounts_on_user_id", using: :btree

  create_table "wishes", force: true do |t|
    t.integer  "venue_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
