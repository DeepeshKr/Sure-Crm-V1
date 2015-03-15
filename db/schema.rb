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

ActiveRecord::Schema.define(version: 20150312082619) do

  create_table "address_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "address_valids", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bills", force: true do |t|
    t.integer  "billno",     limit: nil, precision: 38
    t.datetime "fordate"
    t.integer  "orderid",    limit: nil, precision: 38
    t.string   "fy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaign_playlists", force: true do |t|
    t.string   "name"
    t.integer  "campaignid",       limit: nil, precision: 38
    t.integer  "productvariantid", limit: nil, precision: 38
    t.string   "filename"
    t.text     "description"
    t.decimal  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "channeltapeid"
    t.string   "internaltapeid"
    t.integer  "start_hr",         limit: nil, precision: 38
    t.integer  "start_min",        limit: nil, precision: 38
    t.integer  "start_sec",        limit: nil, precision: 38
    t.integer  "end_hr",           limit: nil, precision: 38
    t.integer  "end_min",          limit: nil, precision: 38
    t.integer  "end_sec",          limit: nil, precision: 38
    t.integer  "duration_secs",    limit: nil, precision: 38
    t.integer  "tape_id",          limit: nil, precision: 38
  end

  create_table "campaign_stages", force: true do |t|
    t.string   "name"
    t.integer  "sortorder",  limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", force: true do |t|
    t.string   "name"
    t.datetime "startdate"
    t.datetime "enddate"
    t.integer  "mediumid",    limit: nil, precision: 38
    t.text     "description"
    t.decimal  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "change_log_trails", force: true do |t|
    t.integer  "changelogtype_id", limit: nil, precision: 38
    t.integer  "refid",            limit: nil, precision: 38
    t.string   "name"
    t.text     "description"
    t.string   "username"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "change_log_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "corporate_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "corporates", force: true do |t|
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
    t.integer  "corporate_type_id", limit: nil, precision: 38
  end

  create_table "customer_addresses", force: true do |t|
    t.integer  "customer_id",   limit: nil, precision: 38
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
    t.integer  "valid_id",      limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "addresstypeid", limit: nil, precision: 38
  end

  create_table "customer_credit_cards", force: true do |t|
    t.integer  "customer_id",      limit: nil, precision: 38
    t.string   "card_no"
    t.string   "name_on_card"
    t.string   "expiry_mon"
    t.string   "expiry_yr_string"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "customer_order_lists", force: true do |t|
    t.integer  "ordernum",   limit: nil, precision: 38
    t.datetime "orderdate"
    t.string   "title",      limit: 5
    t.string   "fname",      limit: 30
    t.string   "lname",      limit: 30
    t.string   "add1",       limit: 30
    t.string   "add2",       limit: 30
    t.string   "add3",       limit: 30
    t.string   "city",       limit: 20
    t.integer  "pincode",    limit: nil, precision: 38
    t.string   "tel1",       limit: 20
    t.string   "tel2",       limit: 20
    t.string   "fax",        limit: 20
    t.string   "email",      limit: 30
    t.string   "ccnumber",   limit: 16
    t.string   "cvc",        limit: 5
    t.string   "cardtype",   limit: 20
    t.string   "expmonth",   limit: 2
    t.string   "expyear",    limit: 4
    t.string   "prod1",      limit: 10
    t.integer  "qty1",       limit: nil, precision: 38
    t.string   "prod2",      limit: 10
    t.integer  "qty2",       limit: nil, precision: 38
    t.string   "prod3",      limit: 10
    t.integer  "qty3",       limit: nil, precision: 38
    t.string   "prod4",      limit: 10
    t.integer  "qty4",       limit: nil, precision: 38
    t.string   "prod5",      limit: 10
    t.integer  "qty5",       limit: nil, precision: 38
    t.string   "prod6",      limit: 10
    t.integer  "qty6",       limit: nil, precision: 38
    t.string   "prod7",      limit: 10
    t.integer  "qty7",       limit: nil, precision: 38
    t.string   "prod8",      limit: 10
    t.integer  "qty8",       limit: nil, precision: 38
    t.string   "prod9",      limit: 10
    t.integer  "qty9",       limit: nil, precision: 38
    t.string   "prod10",     limit: 10
    t.integer  "qty10",      limit: nil, precision: 38
    t.string   "channel",    limit: 50
    t.string   "state",      limit: 5
    t.string   "username",   limit: 50
    t.integer  "oper_no",    limit: nil, precision: 38
    t.string   "recupd",     limit: 1
    t.integer  "dt_hour",    limit: nil, precision: 38
    t.integer  "dt_min",     limit: nil, precision: 38
    t.datetime "birthdate"
    t.string   "mstate",     limit: 50
    t.integer  "people",     limit: nil, precision: 38
    t.integer  "cards",      limit: nil, precision: 38
    t.string   "carddisc",   limit: 50
    t.string   "recfile",    limit: 100
    t.string   "ipadd",      limit: 50
    t.string   "dnis",       limit: 50
    t.string   "landmark",   limit: 50
    t.string   "chqdisc",    limit: 50
    t.integer  "totalamt",   limit: nil, precision: 38
    t.datetime "trandate"
    t.string   "uae_status", limit: 50
    t.string   "emischeme",  limit: 50
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "customers", force: true do |t|
    t.string   "salute"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "mobile"
    t.string   "alt_mobile"
    t.string   "emailid"
    t.string   "alt_emailid"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "state"
  end

  create_table "employee_roles", force: true do |t|
    t.string   "name"
    t.integer  "sortorder",  limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: true do |t|
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "employeecode"
    t.string   "designation"
    t.string   "mobile"
    t.string   "emailid"
    t.string   "location"
    t.integer  "employment_type_id", limit: nil, precision: 38
    t.integer  "employee_role_id",   limit: nil, precision: 38
    t.integer  "reporting_to_id",    limit: nil, precision: 38
    t.boolean  "enablelogin"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reportingto",        limit: nil, precision: 38
  end

  create_table "employment_types", force: true do |t|
    t.string   "name"
    t.integer  "sortorder",  limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interaction_categories", force: true do |t|
    t.string   "name"
    t.integer  "sortorder",       limit: nil, precision: 38
    t.integer  "employeeid",      limit: nil, precision: 38
    t.integer  "resolutionhours", limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "interaction_masters", force: true do |t|
    t.datetime "createdon"
    t.datetime "closedon"
    t.datetime "resolveby"
    t.integer  "interaction_status_id",   limit: nil, precision: 38
    t.integer  "customer_id",             limit: nil, precision: 38
    t.string   "callednumber"
    t.integer  "interaction_category_id", limit: nil, precision: 38
    t.integer  "product_variant_id",      limit: nil, precision: 38
    t.integer  "orderid",                 limit: nil, precision: 38
    t.integer  "interaction_priority_id", limit: nil, precision: 38
    t.integer  "campaign_playlist_id",    limit: nil, precision: 38
    t.text     "notes"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interaction_priorities", force: true do |t|
    t.string   "name"
    t.integer  "sortorder",  limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interaction_statuses", force: true do |t|
    t.string   "customer_description"
    t.string   "internal_description"
    t.integer  "sortorder",            limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interaction_transcripts", force: true do |t|
    t.integer  "interactionid",     limit: nil, precision: 38
    t.string   "interactionuserid"
    t.text     "description"
    t.string   "callednumber"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interaction_users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media", force: true do |t|
    t.string   "name"
    t.string   "telephone"
    t.string   "alttelephone"
    t.string   "state"
    t.boolean  "active"
    t.integer  "corporateid",        limit: nil, precision: 38
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ref_name"
    t.integer  "media_commision_id", limit: nil, precision: 38
    t.decimal  "value"
    t.integer  "media_group_id",     limit: nil, precision: 38
  end

  create_table "media_commisions", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_cost_masters", force: true do |t|
    t.string   "name"
    t.integer  "duration_secs", limit: nil, precision: 38
    t.integer  "cost_per_sec",  limit: nil, precision: 38
    t.integer  "media_id",      limit: nil, precision: 38
    t.integer  "str_hr",        limit: nil, precision: 38
    t.integer  "str_min",       limit: nil, precision: 38
    t.integer  "str_sec",       limit: nil, precision: 38
    t.integer  "end_hr",        limit: nil, precision: 38
    t.integer  "end_min",       limit: nil, precision: 38
    t.integer  "end_sec",       limit: nil, precision: 38
    t.text     "description"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "media_groups", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_tapes", force: true do |t|
    t.string   "name"
    t.integer  "duration_secs",      limit: nil, precision: 38
    t.integer  "tape_ext_ref_id",    limit: nil, precision: 38
    t.string   "unique_tape_name"
    t.integer  "media_id",           limit: nil, precision: 38
    t.integer  "product_variant_id", limit: nil, precision: 38
    t.text     "description"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.datetime "release_date"
  end

  create_table "order_fors", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "order_line_dispatch_statuses", force: true do |t|
    t.string   "name"
    t.integer  "sortorder",  limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_lines", force: true do |t|
    t.integer  "orderid",                  limit: nil, precision: 38
    t.datetime "orderdate"
    t.string   "employeecode"
    t.integer  "employee_id",              limit: nil, precision: 38
    t.string   "external_ref_no"
    t.integer  "productvariant_id",        limit: nil, precision: 38
    t.integer  "pieces",                   limit: nil, precision: 38
    t.decimal  "subtotal"
    t.decimal  "taxes"
    t.decimal  "shipping"
    t.decimal  "codcharges"
    t.decimal  "total"
    t.integer  "orderlinestatusmaster_id", limit: nil, precision: 38
    t.integer  "productline_id",           limit: nil, precision: 38
    t.text     "description"
    t.datetime "estimatedshipdate"
    t.datetime "estimatedarrivaldate"
    t.datetime "orderchecked"
    t.datetime "actualshippate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_list_id",          limit: nil, precision: 38
    t.integer  "product_master_id",        limit: nil, precision: 38
  end

  create_table "order_masters", force: true do |t|
    t.datetime "orderdate"
    t.string   "employeecode"
    t.integer  "employee_id",            limit: nil, precision: 38
    t.integer  "customer_id",            limit: nil, precision: 38
    t.integer  "customer_address_id",    limit: nil, precision: 38
    t.string   "billno"
    t.string   "external_order_no"
    t.integer  "pieces",                 limit: nil, precision: 38
    t.decimal  "subtotal"
    t.decimal  "taxes"
    t.decimal  "shipping"
    t.decimal  "codcharges"
    t.decimal  "total"
    t.integer  "order_status_master_id", limit: nil, precision: 38
    t.integer  "orderpaymentmode_id",    limit: nil, precision: 38
    t.integer  "campaign_playlist_id",   limit: nil, precision: 38
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "calledno"
    t.integer  "order_source_id",        limit: nil, precision: 38
    t.integer  "media_id",               limit: nil, precision: 38
    t.integer  "corporate_id",           limit: nil, precision: 38
    t.integer  "order_for_id",           limit: nil, precision: 38
    t.string   "userip"
    t.string   "sessionid"
  end

  create_table "order_payments", force: true do |t|
    t.integer  "order_master_id",     limit: nil, precision: 38
    t.string   "ref_no"
    t.integer  "orderpaymentmode_id", limit: nil, precision: 38
    t.datetime "paid_date"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "order_sources", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_status_masters", force: true do |t|
    t.string   "name"
    t.integer  "sortorder",  limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orderpaymentmodes", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "charges"
  end

  create_table "product_active_codes", force: true do |t|
    t.string   "name"
    t.integer  "sortorder",  limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_categories", force: true do |t|
    t.string   "name"
    t.decimal  "vatpercent"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_inventory_codes", force: true do |t|
    t.string   "name"
    t.integer  "sortorder",  limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_lists", force: true do |t|
    t.integer  "product_variant_id",   limit: nil, precision: 38
    t.integer  "product_spec_list_id", limit: nil, precision: 38
    t.string   "extproductcode"
    t.string   "list_barcode"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "active_status_id",     limit: nil, precision: 38
    t.string   "name"
  end

  create_table "product_masters", force: true do |t|
    t.string   "name"
    t.integer  "productcategoryid",      limit: nil, precision: 38
    t.integer  "productinventorycodeid", limit: nil, precision: 38
    t.string   "barcode"
    t.decimal  "price"
    t.decimal  "taxes"
    t.decimal  "total"
    t.string   "extproductcode"
    t.text     "description"
    t.integer  "productactivecodeid",    limit: nil, precision: 38
    t.decimal  "costprice"
    t.decimal  "costtaxes"
    t.decimal  "costtotal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "shipping"
    t.integer  "product_sell_type_id",   limit: nil, precision: 38
  end

  create_table "product_sell_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "product_spec_lists", force: true do |t|
    t.string   "name"
    t.string   "spec_1"
    t.string   "spec_2"
    t.string   "spec_3"
    t.string   "spec_4"
    t.string   "spec_5"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "product_training_headings", force: true do |t|
    t.string   "name"
    t.integer  "sortorder",  limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_training_manuals", force: true do |t|
    t.integer  "productid",                   limit: nil, precision: 38
    t.string   "name"
    t.text     "description"
    t.text     "quicknotes"
    t.integer  "product_training_heading_id", limit: nil, precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_variant_add_ons", force: true do |t|
    t.integer  "product_master_id",  limit: nil, precision: 38
    t.integer  "product_variant_id", limit: nil, precision: 38
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "product_variants", force: true do |t|
    t.string   "name"
    t.integer  "productmasterid",      limit: nil, precision: 38
    t.string   "variantbarcode"
    t.decimal  "price"
    t.decimal  "taxes"
    t.decimal  "total"
    t.string   "extproductcode"
    t.text     "description"
    t.integer  "activeid",             limit: nil, precision: 38
    t.decimal  "shipping"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_sell_type_id", limit: nil, precision: 38
  end

  create_table "product_warehouses", force: true do |t|
    t.string   "location_name"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "landmark"
    t.string   "city"
    t.string   "pincode"
    t.string   "state"
    t.string   "country"
    t.string   "telephone1"
    t.string   "telephone2"
    t.string   "fax"
    t.string   "emailid"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "salutes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "employee_code"
    t.string   "emailid"
    t.string   "userip"
    t.string   "sessionid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "employee_code"
    t.integer  "role",            limit: nil, precision: 38
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["employee_code"], name: "index_users_on_employee_code", unique: true

  create_table "vpp_test", id: false, force: true do |t|
    t.integer "asd", limit: nil, precision: 5
  end

end
