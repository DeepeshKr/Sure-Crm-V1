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

ActiveRecord::Schema.define(version: 20150811190113) do

  create_table "address_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "address_valids", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bills", force: :cascade do |t|
    t.integer  "billno",     limit: 16, precision: 38
    t.datetime "fordate"
    t.integer  "orderid",    limit: 16, precision: 38
    t.string   "fy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_image_galleries", force: :cascade do |t|
    t.integer  "bootsy_resource_id",   limit: 16, precision: 38
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: :cascade do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id", limit: 16, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_play_list_statuses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "campaign_playlists", force: :cascade do |t|
    t.string   "name"
    t.integer  "campaignid",        limit: 16, precision: 38
    t.integer  "productvariantid",  limit: 16, precision: 38
    t.string   "filename"
    t.text     "description"
    t.decimal  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "channeltapeid"
    t.string   "internaltapeid"
    t.integer  "start_hr",          limit: 16, precision: 38
    t.integer  "start_min",         limit: 16, precision: 38
    t.integer  "start_sec",         limit: 16, precision: 38
    t.integer  "end_hr",            limit: 16, precision: 38
    t.integer  "end_min",           limit: 16, precision: 38
    t.integer  "end_sec",           limit: 16, precision: 38
    t.integer  "duration_secs",     limit: 16, precision: 38
    t.integer  "tape_id",           limit: 16, precision: 38
    t.string   "ref_name"
    t.integer  "list_status_id",    limit: 16, precision: 38
    t.datetime "for_date"
    t.integer  "total_revenue",     limit: 16, precision: 38
    t.integer  "playlist_group_id", limit: 16, precision: 38
  end

  create_table "campaign_stages", force: :cascade do |t|
    t.string   "name"
    t.integer  "sortorder",  limit: 16, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string   "name"
    t.datetime "startdate"
    t.datetime "enddate"
    t.integer  "mediumid",      limit: 16, precision: 38
    t.text     "description"
    t.decimal  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_cost",    limit: 16, precision: 38
    t.integer  "total_revenue", limit: 16, precision: 38
  end

  create_table "change_log_trails", force: :cascade do |t|
    t.integer  "changelogtype_id", limit: 16, precision: 38
    t.integer  "refid",            limit: 16, precision: 38
    t.string   "name"
    t.text     "description"
    t.string   "username"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "change_log_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "corporate_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "corporates", force: :cascade do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "landmark"
    t.string   "city"
    t.string   "pincode"
    t.string   "state"
    t.string   "district"
    t.string   "country"
    t.string   "telephone1"
    t.string   "telephone2"
    t.string   "fax"
    t.string   "website"
    t.string   "salute1"
    t.string   "first_name1"
    t.string   "last_name1"
    t.string   "designation1"
    t.string   "mobile1"
    t.string   "emaild1"
    t.string   "salute2"
    t.string   "first_name2"
    t.string   "last_name2"
    t.string   "designation2"
    t.string   "mobile2"
    t.string   "emailid2"
    t.string   "salute3"
    t.string   "first_name3"
    t.string   "last_name3"
    t.string   "designation3"
    t.string   "mobile3"
    t.string   "emailid3"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "corporate_type_id", limit: 16, precision: 38
  end

  create_table "customer_addresses", force: :cascade do |t|
    t.integer  "customer_id",   limit: 16, precision: 38
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "landmark"
    t.string   "city"
    t.string   "pincode"
    t.string   "state"
    t.string   "district"
    t.string   "country"
    t.string   "telephone1"
    t.string   "telephone2"
    t.string   "fax"
    t.text     "description"
    t.integer  "valid_id",      limit: 16, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "addresstypeid", limit: 16, precision: 38
  end

  create_table "customer_credit_cards", force: :cascade do |t|
    t.integer  "customer_id",      limit: 16, precision: 38
    t.string   "card_no"
    t.string   "name_on_card"
    t.string   "expiry_mon"
    t.string   "expiry_yr_string"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

