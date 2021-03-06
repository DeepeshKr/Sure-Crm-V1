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

ActiveRecord::Schema.define(version: 20161221062407) do

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

  create_table "app_comment_display_levels", force: :cascade do |t|
    t.string   "name"
    t.integer  "priority_no", precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "app_comment_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "priority_no", precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "app_feature_comments", force: :cascade do |t|
    t.text     "details"
    t.integer  "app_feature_request_id", precision: 38
    t.integer  "comments_by_id",         precision: 38
    t.integer  "comment_type_id",        precision: 38
    t.integer  "display_level_id",       precision: 38
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "user_image"
  end

  create_table "app_feature_requests", force: :cascade do |t|
    t.string   "name"
    t.integer  "app_id",                     precision: 38
    t.integer  "app_feature_type_id",        precision: 38
    t.text     "problem_this_solves"
    t.text     "mandatory_requirements"
    t.text     "technical_notes"
    t.integer  "request_by",                 precision: 38
    t.datetime "require_by_date"
    t.datetime "estimated_completion_date"
    t.datetime "actual_completion_date"
    t.datetime "user_approved_date"
    t.integer  "user_satisfaction_level_id", precision: 38
    t.integer  "velocity_id",                precision: 38
    t.integer  "current_status_id",          precision: 38
    t.integer  "priority_id",                precision: 38
    t.integer  "assigned_to",                precision: 38
    t.text     "extra_notes"
    t.text     "tables_used"
    t.integer  "estimated_hours",            precision: 38
    t.integer  "actual_hours",               precision: 38
    t.integer  "bug_count",                  precision: 38
    t.integer  "linked_app_feature_id",      precision: 38
    t.integer  "queue_no",                   precision: 38
    t.integer  "comment_count",              precision: 38
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "user_image"
  end

  add_index "app_feature_requests", ["actual_completion_date"], name: "i_app_fea_req_act_com_dat"
  add_index "app_feature_requests", ["app_feature_type_id"], name: "i_app_fea_req_app_fea_typ_id"
  add_index "app_feature_requests", ["current_status_id"], name: "i_app_fea_req_cur_sta_id"
  add_index "app_feature_requests", ["estimated_completion_date"], name: "i_app_fea_req_est_com_dat"
  add_index "app_feature_requests", ["priority_id"], name: "i_app_fea_req_pri_id"
  add_index "app_feature_requests", ["request_by"], name: "i_app_fea_req_req_by"
  add_index "app_feature_requests", ["require_by_date"], name: "i_app_fea_req_req_by_dat"
  add_index "app_feature_requests", ["user_approved_date"], name: "i_app_fea_req_use_app_dat"
  add_index "app_feature_requests", ["user_satisfaction_level_id"], name: "i_app_fea_req_use_sat_lev_id"
  add_index "app_feature_requests", ["velocity_id"], name: "i_app_fea_req_vel_id"

  create_table "app_feature_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "priority_no", precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "app_lists", force: :cascade do |t|
    t.string   "name"
    t.integer  "priority_no",         precision: 38
    t.text     "primary_goal_of_app"
    t.text     "description"
    t.string   "version"
    t.string   "location"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "app_priorities", force: :cascade do |t|
    t.string   "name"
    t.integer  "priority_no", precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "app_statuses", force: :cascade do |t|
    t.string   "name"
    t.integer  "priority_no", precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "app_user_satisfaction_levels", force: :cascade do |t|
    t.string   "name"
    t.integer  "priority_no", precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "app_velocities", force: :cascade do |t|
    t.string   "name"
    t.integer  "priority_no", precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "bills", force: :cascade do |t|
    t.integer  "billno",     precision: 38
    t.datetime "fordate"
    t.integer  "orderid",    precision: 38
    t.string   "fy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_image_galleries", force: :cascade do |t|
    t.integer  "bootsy_resource_id",   precision: 38
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: :cascade do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id", precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cable_operator_comms", force: :cascade do |t|
    t.integer  "order_no",        precision: 38
    t.datetime "order_date"
    t.string   "channel"
    t.string   "product"
    t.integer  "amount",          precision: 38
    t.string   "customer_name"
    t.string   "city"
    t.integer  "comm",            precision: 38
    t.text     "description"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "order_id",        precision: 38
    t.integer  "media_id",        precision: 38
    t.integer  "transdetails_id", precision: 38
  end

  add_index "cable_operator_comms", ["transdetails_id"], name: "i_cab_ope_com_tra_id"

  create_table "campaign_missed_lists", force: :cascade do |t|
    t.integer  "product_list_id",      precision: 38
    t.integer  "product_variant_id",   precision: 38
    t.integer  "productmaster_id",     precision: 38
    t.string   "external_prod"
    t.string   "reason"
    t.text     "description"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.decimal  "time_diff"
    t.datetime "order_time"
    t.datetime "play_list_time"
    t.integer  "order_id",             precision: 38
    t.integer  "campaign_id",          precision: 38
    t.integer  "campaign_playlist_id", precision: 38
    t.string   "called_no"
    t.string   "customer_state"
    t.integer  "media_id",             precision: 38
  end

  create_table "campaign_play_list_statuses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "campaign_playlist_to_products", force: :cascade do |t|
    t.string   "name"
    t.integer  "campaign_playlist_id", precision: 38
    t.integer  "product_variant_id",   precision: 38
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "campaign_playlist_to_products", ["campaign_playlist_id"], name: "i_cam_pla_to_pro_cam_pla_id"
  add_index "campaign_playlist_to_products", ["product_variant_id"], name: "i_cam_pla_to_pro_pro_var_id"

  create_table "campaign_playlists", force: :cascade do |t|
    t.string   "name"
    t.integer  "campaignid",        precision: 38
    t.integer  "productvariantid",  precision: 38
    t.string   "filename"
    t.text     "description"
    t.decimal  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "channeltapeid"
    t.string   "internaltapeid"
    t.integer  "start_hr",          precision: 38
    t.integer  "start_min",         precision: 38
    t.integer  "start_sec",         precision: 38
    t.integer  "end_hr",            precision: 38
    t.integer  "end_min",           precision: 38
    t.integer  "end_sec",           precision: 38
    t.integer  "duration_secs",     precision: 38
    t.integer  "tape_id",           precision: 38
    t.string   "ref_name"
    t.integer  "list_status_id",    precision: 38
    t.datetime "for_date"
    t.integer  "total_revenue",     precision: 38
    t.integer  "playlist_group_id", precision: 38
    t.integer  "start_frame",       precision: 38
    t.integer  "end_frame",         precision: 38
    t.integer  "frames",            precision: 38
    t.integer  "day",               precision: 38
    t.decimal  "group_total_cost",  precision: 12, scale: 4
  end

  add_index "campaign_playlists", ["campaignid"], name: "i_cam_pla_cam"
  add_index "campaign_playlists", ["channeltapeid"], name: "i_cam_pla_cha"
  add_index "campaign_playlists", ["end_hr"], name: "i_campaign_playlists_end_hr"
  add_index "campaign_playlists", ["end_min"], name: "i_campaign_playlists_end_min"
  add_index "campaign_playlists", ["end_sec"], name: "i_campaign_playlists_end_sec"
  add_index "campaign_playlists", ["for_date"], name: "i_campaign_playlists_for_date"
  add_index "campaign_playlists", ["list_status_id"], name: "i_cam_pla_lis_sta_id"
  add_index "campaign_playlists", ["playlist_group_id"], name: "i_cam_pla_pla_gro_id"
  add_index "campaign_playlists", ["productvariantid"], name: "i_cam_pla_pro"
  add_index "campaign_playlists", ["start_hr"], name: "i_campaign_playlists_start_hr"
  add_index "campaign_playlists", ["start_min"], name: "i_campaign_playlists_start_min"
  add_index "campaign_playlists", ["start_sec"], name: "i_campaign_playlists_start_sec"

  create_table "campaign_stages", force: :cascade do |t|
    t.string   "name"
    t.integer  "sortorder",  precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string   "name"
    t.datetime "startdate"
    t.datetime "enddate"
    t.integer  "mediumid",      precision: 38
    t.text     "description"
    t.decimal  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_cost",    precision: 38
    t.integer  "total_revenue", precision: 38
  end

  add_index "campaigns", ["mediumid"], name: "index_campaigns_on_mediumid"
  add_index "campaigns", ["startdate"], name: "index_campaigns_on_startdate"

  create_table "change_log_trails", force: :cascade do |t|
    t.integer  "changelogtype_id", precision: 38
    t.integer  "refid",            precision: 38
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

  create_table "corporate_active_masters", force: :cascade do |t|
    t.string   "name"
    t.integer  "sort_order",  precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
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
    t.integer  "corporate_type_id",  precision: 38
    t.integer  "active",             precision: 38
    t.string   "tally_id"
    t.string   "c_form"
    t.string   "cst_no"
    t.string   "gst_no"
    t.string   "vat_no"
    t.string   "tin_no"
    t.decimal  "rupee_balance",      precision: 14, scale: 2
    t.integer  "web_id",             precision: 38
    t.integer  "ref_no",             precision: 38
    t.decimal  "commission_percent", precision: 5,  scale: 4
    t.string   "pan_card_no"
  end

  create_table "courier_lists", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.text     "contact_details"
    t.string   "tracking_url"
    t.string   "helpline"
    t.integer  "sort_order",      precision: 38
    t.string   "ref_code"
    t.integer  "active",          precision: 38
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "cust_details_track_logs", force: :cascade do |t|
    t.integer  "cust_details_track_id", precision: 38
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "cust_details_track_logs", ["cust_details_track_id"], name: "if88e44c584a16c852aa0173a4afab"

  create_table "cust_details_tracks", force: :cascade do |t|
    t.integer  "order_master_id",   precision: 38
    t.integer  "order_ref_id",      precision: 38
    t.datetime "order_date"
    t.integer  "ext_ref_id",        precision: 38
    t.integer  "custdetails",       precision: 38
    t.integer  "vpp",               precision: 38
    t.integer  "dealtran",          precision: 38
    t.datetime "last_call_back_on"
    t.integer  "no_of_attempts",    precision: 38
    t.string   "mobile"
    t.string   "alt_mobile"
    t.text     "products"
    t.string   "current_status"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "cust_details_tracks", ["alt_mobile"], name: "i_cus_det_tra_alt_mob"
  add_index "cust_details_tracks", ["custdetails"], name: "i_cus_det_tra_cus"
  add_index "cust_details_tracks", ["dealtran"], name: "i_cust_details_tracks_dealtran"
  add_index "cust_details_tracks", ["ext_ref_id"], name: "i_cus_det_tra_ext_ref_id"
  add_index "cust_details_tracks", ["last_call_back_on"], name: "i_cus_det_tra_las_cal_bac_on"
  add_index "cust_details_tracks", ["mobile"], name: "i_cust_details_tracks_mobile"
  add_index "cust_details_tracks", ["order_date"], name: "i_cus_det_tra_ord_dat"
  add_index "cust_details_tracks", ["order_master_id"], name: "i_cus_det_tra_ord_mas_id"
  add_index "cust_details_tracks", ["vpp"], name: "i_cust_details_tracks_vpp"

  create_table "customer_addresses", force: :cascade do |t|
    t.integer  "customer_id",   precision: 38
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
    t.integer  "valid_id",      precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "addresstypeid", precision: 38
  end

  create_table "customer_credit_cards", force: :cascade do |t|
    t.integer  "customer_id",      precision: 38
    t.string   "card_no"
    t.string   "name_on_card"
    t.string   "expiry_mon"
    t.string   "expiry_yr_string"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "customer_order_lists", force: :cascade do |t|
    t.integer  "ordernum",                precision: 38
    t.datetime "orderdate"
    t.string   "title",       limit: 5
    t.string   "fname",       limit: 30
    t.string   "lname",       limit: 30
    t.string   "add1",        limit: 30
    t.string   "add2",        limit: 30
    t.string   "add3",        limit: 30
    t.string   "city",        limit: 20
    t.integer  "pincode",                 precision: 38
    t.string   "tel1",        limit: 20
    t.string   "tel2",        limit: 20
    t.string   "fax",         limit: 20
    t.string   "email",       limit: 30
    t.string   "ccnumber",    limit: 16
    t.string   "cvc",         limit: 5
    t.string   "cardtype",    limit: 20
    t.string   "expmonth",    limit: 2
    t.string   "expyear",     limit: 4
    t.string   "prod1",       limit: 10
    t.integer  "qty1",                    precision: 38
    t.string   "prod2",       limit: 10
    t.integer  "qty2",                    precision: 38
    t.string   "prod3",       limit: 10
    t.integer  "qty3",                    precision: 38
    t.string   "prod4",       limit: 10
    t.integer  "qty4",                    precision: 38
    t.string   "prod5",       limit: 10
    t.integer  "qty5",                    precision: 38
    t.string   "prod6",       limit: 10
    t.integer  "qty6",                    precision: 38
    t.string   "prod7",       limit: 10
    t.integer  "qty7",                    precision: 38
    t.string   "prod8",       limit: 10
    t.integer  "qty8",                    precision: 38
    t.string   "prod9",       limit: 10
    t.integer  "qty9",                    precision: 38
    t.string   "prod10",      limit: 10
    t.integer  "qty10",                   precision: 38
    t.string   "channel",     limit: 50
    t.string   "state",       limit: 5
    t.string   "username",    limit: 50
    t.integer  "oper_no",                 precision: 38
    t.string   "recupd",      limit: 1
    t.integer  "dt_hour",                 precision: 38
    t.integer  "dt_min",                  precision: 38
    t.datetime "birthdate"
    t.string   "mstate",      limit: 50
    t.integer  "people",                  precision: 38
    t.integer  "cards",                   precision: 38
    t.string   "carddisc",    limit: 50
    t.string   "recfile",     limit: 100
    t.string   "ipadd",       limit: 50
    t.string   "dnis",        limit: 50
    t.string   "landmark",    limit: 50
    t.string   "chqdisc",     limit: 50
    t.integer  "totalamt",                precision: 38
    t.datetime "trandate"
    t.string   "uae_status",  limit: 50
    t.string   "emischeme",   limit: 50
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "order_id",                precision: 38
    t.string   "dept_master"
    t.string   "state_code"
    t.datetime "in_date"
  end

  add_index "customer_order_lists", ["city"], name: "i_customer_order_lists_city"
  add_index "customer_order_lists", ["dept_master"], name: "i_cus_ord_lis_dep_mas"
  add_index "customer_order_lists", ["order_id"], name: "i_cus_ord_lis_ord_id"
  add_index "customer_order_lists", ["ordernum"], name: "i_cus_ord_lis_ord"
  add_index "customer_order_lists", ["pincode"], name: "i_customer_order_lists_pincode"
  add_index "customer_order_lists", ["prod1"], name: "i_customer_order_lists_prod1"
  add_index "customer_order_lists", ["state"], name: "i_customer_order_lists_state"
  add_index "customer_order_lists", ["state_code"], name: "i_cus_ord_lis_sta_cod"
  add_index "customer_order_lists", ["tel1"], name: "i_customer_order_lists_tel1"
  add_index "customer_order_lists", ["tel2"], name: "i_customer_order_lists_tel2"

  create_table "customers", force: :cascade do |t|
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
    t.datetime "date_of_birth"
    t.decimal  "bajaj_finance_ecs", precision: 10, scale: 4
  end

  add_index "customers", ["alt_emailid"], name: "index_customers_on_alt_emailid"
  add_index "customers", ["alt_mobile"], name: "index_customers_on_alt_mobile"
  add_index "customers", ["city"], name: "index_customers_on_city"
  add_index "customers", ["date_of_birth"], name: "i_customers_date_of_birth"
  add_index "customers", ["emailid"], name: "index_customers_on_emailid"
  add_index "customers", ["mobile"], name: "index_customers_on_mobile"
  add_index "customers", ["state"], name: "index_customers_on_state"

  create_table "daily_task_logs", force: :cascade do |t|
    t.integer  "daily_task_id", precision: 38
    t.string   "name"
    t.text     "syntax_error"
    t.string   "status"
    t.datetime "checked_on"
    t.string   "checked_by"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "daily_tasks", force: :cascade do |t|
    t.integer  "sort_order",  precision: 38
    t.string   "name"
    t.string   "frequency"
    t.text     "description"
    t.text     "syntax"
    t.text     "parameters"
    t.string   "status"
    t.string   "department"
    t.string   "manager"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   precision: 38, default: 0, null: false
    t.integer  "attempts",   precision: 38, default: 0, null: false
    t.text     "handler",                               null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "devises", force: :cascade do |t|
    t.string   "email",                                 default: "", null: false
    t.string   "encrypted_password",                    default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          precision: 38, default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "devises", ["email"], name: "index_devises_on_email", unique: true
  add_index "devises", ["reset_password_token"], name: "i_devises_reset_password_token", unique: true

  create_table "dispatch_call_statuses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "sort_order",  precision: 38
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "dispatch_call_statuses", ["name"], name: "i_dispatch_call_statuses_name"
  add_index "dispatch_call_statuses", ["sort_order"], name: "i_dis_cal_sta_sor_ord"

  create_table "distributor_missed_order_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "sort_order",  precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "distributor_missed_orders", force: :cascade do |t|
    t.integer  "corporate_id",   precision: 38
    t.integer  "missed_type_id", precision: 38
    t.integer  "order_value",    precision: 38
    t.integer  "order_no",       precision: 38
    t.integer  "order_id",       precision: 38
    t.text     "description"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "distributor_missed_pincodes", force: :cascade do |t|
    t.string   "pincode"
    t.integer  "no_of_orders", precision: 38
    t.decimal  "total_value"
    t.datetime "last_ran_on"
    t.text     "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "distributor_pincode_lists", force: :cascade do |t|
    t.string   "city"
    t.string   "state"
    t.string   "locality"
    t.integer  "sort_order",   precision: 38
    t.string   "pincode"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "corporate_id", precision: 38
  end

  add_index "distributor_pincode_lists", ["pincode"], name: "i_dis_pin_lis_pin"

  create_table "distributor_product_lists", force: :cascade do |t|
    t.integer  "product_list_id", precision: 38
    t.string   "name"
    t.integer  "sort_order",      precision: 38
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "distributor_stock_books", force: :cascade do |t|
    t.integer  "corporate_id",       precision: 38
    t.integer  "product_master_id",  precision: 38
    t.integer  "product_variant_id", precision: 38
    t.integer  "product_list_id",    precision: 38
    t.string   "prod"
    t.integer  "opening_qty",        precision: 38
    t.decimal  "opening_value",      precision: 10, scale: 2
    t.integer  "sold_qty",           precision: 38
    t.decimal  "sold_value",         precision: 10, scale: 2
    t.integer  "return_qty",         precision: 38
    t.decimal  "return_value",       precision: 10, scale: 2
    t.integer  "closing_qty",        precision: 38
    t.decimal  "closing_value",      precision: 10, scale: 2
    t.datetime "book_date"
    t.string   "list_barcode"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "distributor_stock_ledger_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "sort_order",  precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "distributor_stock_ledgers", force: :cascade do |t|
    t.integer  "corporate_id",       precision: 38
    t.integer  "product_master_id",  precision: 38
    t.integer  "product_variant_id", precision: 38
    t.integer  "product_list_id",    precision: 38
    t.string   "prod"
    t.string   "name"
    t.text     "description"
    t.decimal  "stock_change"
    t.datetime "ledger_date"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "type_id",            precision: 38
    t.decimal  "stock_value",        precision: 10, scale: 2
  end

  create_table "distributor_stock_summaries", force: :cascade do |t|
    t.integer  "corporate_id",       precision: 38
    t.integer  "product_master_id",  precision: 38
    t.integer  "product_variant_id", precision: 38
    t.integer  "product_list_id",    precision: 38
    t.string   "prod"
    t.integer  "stock_qty",          precision: 38
    t.integer  "stock_value",        precision: 38
    t.integer  "stock_returned",     precision: 38
    t.datetime "summary_date"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "distributor_upload_orders", force: :cascade do |t|
    t.integer  "order_id",           precision: 38
    t.integer  "ext_order_id",       precision: 38
    t.datetime "last_ran_on"
    t.text     "description"
    t.integer  "online_order_id",    precision: 38
    t.datetime "online_last_ran_on"
    t.text     "online_description"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "employee_roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "sortorder",  precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: :cascade do |t|
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "employeecode"
    t.string   "designation"
    t.string   "mobile"
    t.string   "emailid"
    t.string   "location"
    t.integer  "employment_type_id",             precision: 38
    t.integer  "employee_role_id",               precision: 38
    t.integer  "reporting_to_id",                precision: 38
    t.boolean  "enablelogin",        limit: nil
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reportingto",                    precision: 38
    t.string   "pic"
  end

  create_table "employment_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "sortorder",  precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "errors", force: :cascade do |t|
    t.string   "usable_type"
    t.integer  "usable_id",   precision: 38
    t.text     "class_name"
    t.text     "message"
    t.text     "trace"
    t.text     "target_url"
    t.text     "referer_url"
    t.text     "params"
    t.text     "user_agent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "external_users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "encrypted_password"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "fat_to_fit_email_statuses", force: :cascade do |t|
    t.string   "emailid"
    t.string   "full_name"
    t.string   "products"
    t.integer  "order_no",               precision: 38
    t.integer  "order_id",               precision: 38
    t.integer  "send_status",            precision: 38
    t.datetime "last_ran_date"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "phone"
    t.string   "state"
    t.string   "city"
    t.integer  "registration_status_id", precision: 38
  end

  create_table "fedex_bill_checks", force: :cascade do |t|
    t.integer  "shp_cust_nbr",                             precision: 38
    t.integer  "acctno",                                   precision: 38
    t.integer  "invno",                                    precision: 38
    t.datetime "invdate"
    t.integer  "awb",                                      precision: 38
    t.datetime "shipdate"
    t.string   "shprname"
    t.string   "coname"
    t.string   "shipadd"
    t.string   "shprlocation"
    t.string   "shp_postal_code"
    t.string   "shipreference"
    t.string   "origloc",                        limit: 5
    t.string   "origctry",                       limit: 5
    t.string   "destloc",                        limit: 5
    t.string   "destctry",                       limit: 5
    t.integer  "svc1",                                     precision: 38
    t.integer  "pcs",                                      precision: 38
    t.integer  "weight",                                   precision: 38
    t.integer  "dimwgt",                                   precision: 38
    t.string   "wgttype",                        limit: 5
    t.string   "dimflag",                        limit: 5
    t.string   "billflag",                       limit: 5
    t.decimal  "ratedamt"
    t.decimal  "discount"
    t.decimal  "address_correction"
    t.decimal  "cod_fee"
    t.decimal  "freight_on_value_carriers_risk"
    t.decimal  "freight_on_value_own_risk"
    t.decimal  "fuel_surcharge"
    t.decimal  "higher_floor_delivery"
    t.decimal  "india_service_tax"
    t.decimal  "out_of_delivery_area"
    t.decimal  "billedamt"
    t.string   "recp_pstl_cd"
    t.string   "verif_name"
    t.integer  "verif_order_ref_id",                       precision: 38
    t.integer  "verif_order_no",                           precision: 38
    t.string   "verif_products"
    t.integer  "verif_weight",                             precision: 38
    t.integer  "verif_weight_diff",                        precision: 38
    t.text     "verif_comments"
    t.decimal  "verif_basic"
    t.decimal  "verif_fuel_surcharge"
    t.decimal  "verif_cod"
    t.decimal  "verif_service_tax"
    t.decimal  "verif_total_charges"
    t.datetime "verif_upload_date"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  create_table "help_files", force: :cascade do |t|
    t.string   "name"
    t.string   "link"
    t.text     "description"
    t.text     "code_used"
    t.text     "database_used"
    t.string   "tags"
    t.integer  "employee_id",   precision: 38
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "domain"
    t.string   "controller"
    t.string   "action"
    t.string   "screen_shot"
    t.text     "parameters"
  end

  add_index "help_files", ["action"], name: "index_help_files_on_action"
  add_index "help_files", ["controller"], name: "index_help_files_on_controller"
  add_index "help_files", ["link"], name: "index_help_files_on_link"
  add_index "help_files", ["tags"], name: "index_help_files_on_tags"

  create_table "india_city_lists", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "india_pincode_lists", force: :cascade do |t|
    t.string   "officename"
    t.string   "pincode"
    t.string   "deliverystatus"
    t.string   "divisionname"
    t.string   "regionname"
    t.string   "circlename"
    t.string   "taluk"
    t.string   "districtname"
    t.string   "statename"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "india_pincode_lists", ["circlename"], name: "i_ind_pin_lis_cir"
  add_index "india_pincode_lists", ["districtname"], name: "i_ind_pin_lis_dis"
  add_index "india_pincode_lists", ["divisionname"], name: "i_ind_pin_lis_div"
  add_index "india_pincode_lists", ["officename"], name: "i_ind_pin_lis_off"
  add_index "india_pincode_lists", ["pincode"], name: "i_india_pincode_lists_pincode"
  add_index "india_pincode_lists", ["regionname"], name: "i_ind_pin_lis_reg"
  add_index "india_pincode_lists", ["statename"], name: "i_ind_pin_lis_sta"
  add_index "india_pincode_lists", ["taluk"], name: "i_india_pincode_lists_taluk"

  create_table "interaction_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "sortorder",       precision: 38
    t.integer  "employeeid",      precision: 38
    t.integer  "resolutionhours", precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "interaction_masters", force: :cascade do |t|
    t.datetime "createdon"
    t.datetime "closedon"
    t.datetime "resolveby"
    t.integer  "interaction_status_id",   precision: 38
    t.integer  "customer_id",             precision: 38
    t.string   "callednumber"
    t.integer  "interaction_category_id", precision: 38
    t.integer  "product_variant_id",      precision: 38
    t.integer  "orderid",                 precision: 38
    t.integer  "interaction_priority_id", precision: 38
    t.integer  "campaign_playlist_id",    precision: 38
    t.text     "notes"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mobile"
    t.integer  "employee_id",             precision: 38
    t.string   "employee_code"
  end

  add_index "interaction_masters", ["campaign_playlist_id"], name: "i_int_mas_cam_pla_id"
  add_index "interaction_masters", ["customer_id"], name: "i_int_mas_cus_id"
  add_index "interaction_masters", ["employee_code"], name: "i_int_mas_emp_cod"
  add_index "interaction_masters", ["employee_id"], name: "i_int_mas_emp_id"
  add_index "interaction_masters", ["interaction_category_id"], name: "i_int_mas_int_cat_id"
  add_index "interaction_masters", ["interaction_status_id"], name: "i_int_mas_int_sta_id"
  add_index "interaction_masters", ["mobile"], name: "i_interaction_masters_mobile"
  add_index "interaction_masters", ["orderid"], name: "i_interaction_masters_orderid"

  create_table "interaction_priorities", force: :cascade do |t|
    t.string   "name"
    t.integer  "sortorder",  precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interaction_statuses", force: :cascade do |t|
    t.string   "customer_description"
    t.string   "internal_description"
    t.integer  "sortorder",            precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interaction_transcripts", force: :cascade do |t|
    t.integer  "interactionid",     precision: 38
    t.string   "interactionuserid"
    t.text     "description"
    t.string   "callednumber"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id",       precision: 38
    t.string   "ip"
  end

  create_table "interaction_users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "list_of_servers", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "active_since"
    t.string   "internal_ip"
    t.string   "vpn_ip"
    t.string   "external_ip"
    t.string   "current_status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "logins", force: :cascade do |t|
    t.string   "email",                                 default: "", null: false
    t.string   "encrypted_password",                    default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          precision: 38, default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "logins", ["email"], name: "index_logins_on_email", unique: true
  add_index "logins", ["reset_password_token"], name: "i_logins_reset_password_token", unique: true

  create_table "marketing_messages", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "total_nos",                       precision: 38
    t.boolean  "activate",            limit: nil
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "order_paymentmodeid",             precision: 38
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "marketing_messages", ["end_date"], name: "i_marketing_messages_end_date"
  add_index "marketing_messages", ["order_paymentmodeid"], name: "i_mar_mes_ord_pay"
  add_index "marketing_messages", ["start_date"], name: "i_mar_mes_sta_dat"

  create_table "media", force: :cascade do |t|
    t.string   "name"
    t.string   "telephone"
    t.string   "alttelephone"
    t.string   "state"
    t.boolean  "active",             limit: nil
    t.integer  "corporateid",                    precision: 38
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ref_name"
    t.integer  "media_commision_id",             precision: 38
    t.decimal  "value"
    t.integer  "media_group_id",                 precision: 38
    t.string   "dnis"
    t.string   "channel"
    t.string   "slot"
    t.integer  "daily_charges",                  precision: 38
    t.decimal  "paid_correction",                precision: 6,  scale: 5
    t.integer  "employee_id",                    precision: 38
    t.string   "dept"
    t.decimal  "agent_comm",                     precision: 8,  scale: 4
  end

  add_index "media", ["daily_charges"], name: "index_media_on_daily_charges"
  add_index "media", ["dept"], name: "index_media_on_dept"
  add_index "media", ["dnis"], name: "index_media_on_dnis"
  add_index "media", ["id", "media_group_id"], name: "media_idx01"
  add_index "media", ["media_commision_id"], name: "i_media_media_commision_id"
  add_index "media", ["media_group_id"], name: "index_media_on_media_group_id"
  add_index "media", ["name"], name: "index_media_on_name"
  add_index "media", ["ref_name"], name: "index_media_on_ref_name"
  add_index "media", ["telephone"], name: "index_media_on_telephone"

  create_table "media_commisions", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_cost_masters", force: :cascade do |t|
    t.string   "name"
    t.integer  "duration_secs", precision: 38
    t.decimal  "total_cost",    precision: 10, scale: 2
    t.integer  "media_id",      precision: 38
    t.integer  "str_hr",        precision: 38
    t.integer  "str_min",       precision: 38
    t.integer  "str_sec",       precision: 38
    t.integer  "end_hr",        precision: 38
    t.integer  "end_min",       precision: 38
    t.integer  "end_sec",       precision: 38
    t.text     "description"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.decimal  "slot_percent",  precision: 5,  scale: 4
    t.decimal  "cost_per_sec",  precision: 10, scale: 4
    t.integer  "starting_sec",  precision: 38
    t.integer  "ending_sec",    precision: 38
  end

  add_index "media_cost_masters", ["ending_sec"], name: "i_med_cos_mas_end_sec"
  add_index "media_cost_masters", ["starting_sec"], name: "i_med_cos_mas_sta_sec"

  create_table "media_groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_tape_heads", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "product_variant_id", precision: 38
  end

  create_table "media_tapes", force: :cascade do |t|
    t.string   "name"
    t.integer  "duration_secs",      precision: 38
    t.integer  "tape_ext_ref_id",    precision: 38
    t.string   "unique_tape_name"
    t.integer  "media_id",           precision: 38
    t.integer  "product_variant_id", precision: 38
    t.text     "description"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.datetime "release_date"
    t.integer  "media_tape_head_id", precision: 38
    t.integer  "sort_order",         precision: 38
    t.integer  "frames",             precision: 38
    t.string   "mxf_tape_home"
    t.integer  "mxf_seconds",        precision: 38
    t.integer  "mxf_frame",          precision: 38
    t.string   "tape_choice"
  end

  create_table "message_on_orders", force: :cascade do |t|
    t.integer  "customer_id",                      precision: 38
    t.integer  "message_type_id",                  precision: 38
    t.integer  "message_status_id",                precision: 38
    t.string   "message",              limit: 500
    t.string   "response"
    t.string   "mobile_no"
    t.string   "alt_mobile_no"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "order_id",                         precision: 38
    t.text     "long_url"
    t.integer  "marketing_message_id",             precision: 38
  end

  add_index "message_on_orders", ["customer_id"], name: "i_mes_on_ord_cus_id"
  add_index "message_on_orders", ["marketing_message_id"], name: "i_mes_on_ord_mar_mes_id"
  add_index "message_on_orders", ["message_status_id"], name: "i_mes_on_ord_mes_sta_id"
  add_index "message_on_orders", ["message_type_id"], name: "i_mes_on_ord_mes_typ_id"
  add_index "message_on_orders", ["mobile_no"], name: "i_message_on_orders_mobile_no"
  add_index "message_on_orders", ["order_id"], name: "i_message_on_orders_order_id"

  create_table "message_statuses", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "sort_order",  precision: 38
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "message_types", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "sort_order",  precision: 38
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "order_dispatch_statuses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "sort_order",  precision: 38
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "order_dispatch_statuses", ["name"], name: "i_order_dispatch_statuses_name"
  add_index "order_dispatch_statuses", ["sort_order"], name: "i_ord_dis_sta_sor_ord"

  create_table "order_final_statuses", force: :cascade do |t|
    t.string   "name"
    t.integer  "sort_order",  precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "order_fors", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "order_line_dispatch_statuses", force: :cascade do |t|
    t.string   "name"
    t.integer  "sortorder",  precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_lines", force: :cascade do |t|
    t.integer  "orderid",                  precision: 38
    t.datetime "orderdate"
    t.string   "employeecode"
    t.integer  "employee_id",              precision: 38
    t.string   "external_ref_no"
    t.integer  "productvariant_id",        precision: 38
    t.integer  "pieces",                   precision: 38
    t.decimal  "subtotal"
    t.decimal  "taxes"
    t.decimal  "shipping"
    t.decimal  "codcharges"
    t.decimal  "total"
    t.integer  "orderlinestatusmaster_id", precision: 38
    t.integer  "productline_id",           precision: 38
    t.text     "description"
    t.datetime "estimatedshipdate"
    t.datetime "estimatedarrivaldate"
    t.datetime "orderchecked"
    t.datetime "actualshippate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_list_id",          precision: 38
    t.integer  "product_master_id",        precision: 38
  end

  add_index "order_lines", ["orderdate"], name: "index_order_lines_on_orderdate"
  add_index "order_lines", ["orderid", "productvariant_id"], name: "i_ord_lin_ord_pro_id"
  add_index "order_lines", ["orderid"], name: "index_order_lines_on_orderid"
  add_index "order_lines", ["product_list_id"], name: "i_order_lines_product_list_id"
  add_index "order_lines", ["product_master_id"], name: "i_ord_lin_pro_mas_id"
  add_index "order_lines", ["productvariant_id", "orderid"], name: "order_lines_idx01"
  add_index "order_lines", ["productvariant_id"], name: "i_ord_lin_pro_id"

  create_table "order_list_miles", force: :cascade do |t|
    t.string   "name"
    t.integer  "sort_order",  precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "order_masters", force: :cascade do |t|
    t.datetime "orderdate"
    t.string   "employeecode"
    t.integer  "employee_id",            precision: 38
    t.integer  "customer_id",            precision: 38
    t.integer  "customer_address_id",    precision: 38
    t.string   "billno"
    t.string   "external_order_no"
    t.integer  "pieces",                 precision: 38
    t.decimal  "subtotal"
    t.decimal  "taxes"
    t.decimal  "shipping"
    t.decimal  "codcharges"
    t.decimal  "total"
    t.integer  "order_status_master_id", precision: 38
    t.integer  "orderpaymentmode_id",    precision: 38
    t.integer  "campaign_playlist_id",   precision: 38
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "calledno"
    t.integer  "order_source_id",        precision: 38
    t.integer  "media_id",               precision: 38
    t.integer  "corporate_id",           precision: 38
    t.integer  "order_for_id",           precision: 38
    t.string   "userip"
    t.string   "sessionid"
    t.string   "mobile"
    t.integer  "original_order_id",      precision: 38
    t.integer  "promotion_id",           precision: 38
    t.string   "city"
    t.string   "pincode"
    t.integer  "order_last_mile_id",     precision: 38
    t.integer  "order_final_status_id",  precision: 38
    t.decimal  "g_total",                precision: 12, scale: 2
    t.integer  "weight_kg",              precision: 38
    t.integer  "interaction_master_id",  precision: 38
    t.datetime "process_date"
    t.datetime "ship_date"
    t.datetime "cancelled_date"
    t.datetime "paid_date"
    t.datetime "refund_date"
    t.datetime "returned_date"
    t.string   "gender"
  end

  add_index "order_masters", ["TRUNC(\"CREATED_AT\")", "order_status_master_id", "media_id", "id"], name: "order_masters_idx01"
  add_index "order_masters", ["calledno"], name: "i_order_masters_calledno"
  add_index "order_masters", ["campaign_playlist_id"], name: "i_ord_mas_cam_pla_id"
  add_index "order_masters", ["cancelled_date"], name: "i_order_masters_cancelled_date"
  add_index "order_masters", ["city"], name: "index_order_masters_on_city"
  add_index "order_masters", ["created_at"], name: "i_order_masters_created_at"
  add_index "order_masters", ["customer_id"], name: "i_order_masters_customer_id"
  add_index "order_masters", ["employee_id"], name: "i_order_masters_employee_id"
  add_index "order_masters", ["external_order_no"], name: "i_ord_mas_ext_ord_no"
  add_index "order_masters", ["gender"], name: "index_order_masters_on_gender"
  add_index "order_masters", ["interaction_master_id"], name: "i_ord_mas_int_mas_id"
  add_index "order_masters", ["media_id"], name: "i_order_masters_media_id"
  add_index "order_masters", ["mobile"], name: "index_order_masters_on_mobile"
  add_index "order_masters", ["order_source_id"], name: "i_ord_mas_ord_sou_id"
  add_index "order_masters", ["order_status_master_id"], name: "i_ord_mas_ord_sta_mas_id"
  add_index "order_masters", ["orderdate"], name: "i_order_masters_orderdate"
  add_index "order_masters", ["orderpaymentmode_id"], name: "i_ord_mas_ord_id"
  add_index "order_masters", ["paid_date"], name: "i_order_masters_paid_date"
  add_index "order_masters", ["pincode"], name: "index_order_masters_on_pincode"
  add_index "order_masters", ["process_date"], name: "i_order_masters_process_date"
  add_index "order_masters", ["refund_date"], name: "i_order_masters_refund_date"
  add_index "order_masters", ["returned_date"], name: "i_order_masters_returned_date"
  add_index "order_masters", ["ship_date"], name: "i_order_masters_ship_date"

  create_table "order_payments", force: :cascade do |t|
    t.integer  "order_master_id",     precision: 38
    t.string   "ref_no"
    t.integer  "orderpaymentmode_id", precision: 38
    t.datetime "paid_date"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "employee_id",         precision: 38
    t.decimal  "paid_amount",         precision: 10, scale: 4
    t.integer  "order_no",            precision: 38
    t.string   "card_no"
    t.integer  "ecs_limit",           precision: 38
  end

  add_index "order_payments", ["ecs_limit"], name: "i_order_payments_ecs_limit"
  add_index "order_payments", ["employee_id"], name: "i_order_payments_employee_id"
  add_index "order_payments", ["order_master_id"], name: "i_ord_pay_ord_mas_id"
  add_index "order_payments", ["order_no"], name: "i_order_payments_order_no"
  add_index "order_payments", ["orderpaymentmode_id"], name: "i_ord_pay_ord_id"
  add_index "order_payments", ["paid_date"], name: "i_order_payments_paid_date"

  create_table "order_sources", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_status_masters", force: :cascade do |t|
    t.string   "name"
    t.integer  "sortorder",  precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_updates", force: :cascade do |t|
    t.integer  "order_id",                        precision: 38
    t.integer  "order_line_id",                   precision: 38
    t.decimal  "order_value",                     precision: 10, scale: 2
    t.string   "orderno"
    t.datetime "order_date"
    t.datetime "entry_date"
    t.datetime "shipped_date"
    t.datetime "return_date"
    t.datetime "cancel_date"
    t.datetime "refund_date"
    t.datetime "paid_date"
    t.decimal  "paid_value",                      precision: 10, scale: 2
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.boolean  "updated",             limit: nil
    t.datetime "payment_waiting"
    t.string   "payment_description"
  end

  add_index "order_updates", ["order_date"], name: "i_order_updates_order_date"
  add_index "order_updates", ["order_id"], name: "i_order_updates_order_id"
  add_index "order_updates", ["orderno"], name: "index_order_updates_on_orderno"
  add_index "order_updates", ["payment_waiting"], name: "i_ord_upd_pay_wai"

  create_table "orderpaymentmodes", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "charges"
    t.decimal  "payment_cost",             precision: 6,  scale: 4
    t.boolean  "is_valid",     limit: nil
    t.integer  "hold_hours",               precision: 38
  end

  create_table "page_names", force: :cascade do |t|
    t.string   "name"
    t.integer  "sort_order",  precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "page_trails", force: :cascade do |t|
    t.string   "name"
    t.integer  "order_id",      precision: 38
    t.integer  "page_id",       precision: 38
    t.string   "url"
    t.string   "employee_id"
    t.integer  "duration_secs", precision: 38
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.text     "params"
    t.text     "description"
  end

  add_index "page_trails", ["employee_id"], name: "i_page_trails_employee_id"
  add_index "page_trails", ["name"], name: "index_page_trails_on_name"
  add_index "page_trails", ["order_id"], name: "index_page_trails_on_order_id"

  create_table "payumoney_details", force: :cascade do |t|
    t.integer  "paymentId",             precision: 38
    t.string   "merchantTransactionId"
    t.decimal  "amount"
    t.string   "customerMobileNumber"
    t.string   "status"
    t.integer  "orderid",               precision: 38
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "final_order_id"
    t.text     "full_response"
    t.datetime "last_check_at"
    t.text     "message_url"
    t.string   "transaction_ref"
    t.integer  "payumoney_status_id",   precision: 38
    t.text     "transaction_history"
    t.integer  "no_of_links",           precision: 38
    t.datetime "failed_time"
    t.integer  "failed_count",          precision: 38
  end

  add_index "payumoney_details", ["customermobilenumber"], name: "i_pay_det_cus"
  add_index "payumoney_details", ["final_order_id"], name: "i_pay_det_fin_ord_id"
  add_index "payumoney_details", ["merchanttransactionid"], name: "i_pay_det_mer"
  add_index "payumoney_details", ["orderid"], name: "i_payumoney_details_orderid"
  add_index "payumoney_details", ["paymentid"], name: "i_payumoney_details_paymentid"
  add_index "payumoney_details", ["payumoney_status_id"], name: "i_pay_det_pay_sta_id"
  add_index "payumoney_details", ["transaction_ref"], name: "i_pay_det_tra_ref"

  create_table "payumoney_statuses", force: :cascade do |t|
    t.string   "name"
    t.integer  "priority_no",          precision: 38
    t.string   "external_description"
    t.string   "valid_payment"
    t.text     "description"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "pending_orders", force: :cascade do |t|
    t.integer  "order_ref_id",             precision: 38
    t.integer  "order_no",                 precision: 38
    t.integer  "order_dispatch_status_id", precision: 38
    t.integer  "cod_amount",               precision: 38
    t.integer  "pay_u_amount",             precision: 38
    t.integer  "courier_list_id",          precision: 38
    t.integer  "pay_u_status_id",          precision: 38
    t.integer  "dispatch_call_status_id",  precision: 38
    t.string   "airway_bill"
    t.string   "pod"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.datetime "order_date"
    t.string   "tel_1"
    t.string   "tel_2"
    t.string   "manifest"
    t.string   "courier_name"
  end

  add_index "pending_orders", ["airway_bill"], name: "i_pending_orders_airway_bill"
  add_index "pending_orders", ["courier_list_id"], name: "i_pen_ord_cou_lis_id"
  add_index "pending_orders", ["courier_name"], name: "i_pending_orders_courier_name"
  add_index "pending_orders", ["dispatch_call_status_id"], name: "i_pen_ord_dis_cal_sta_id"
  add_index "pending_orders", ["manifest"], name: "i_pending_orders_manifest"
  add_index "pending_orders", ["order_date"], name: "i_pending_orders_order_date"
  add_index "pending_orders", ["order_dispatch_status_id"], name: "i_pen_ord_ord_dis_sta_id"
  add_index "pending_orders", ["order_no"], name: "i_pending_orders_order_no"
  add_index "pending_orders", ["order_ref_id"], name: "i_pending_orders_order_ref_id"
  add_index "pending_orders", ["pay_u_status_id"], name: "i_pen_ord_pay_u_sta_id"
  add_index "pending_orders", ["pod"], name: "index_pending_orders_on_pod"
  add_index "pending_orders", ["tel_1"], name: "index_pending_orders_on_tel_1"
  add_index "pending_orders", ["tel_2"], name: "index_pending_orders_on_tel_2"

  create_table "pincode_service_levels", force: :cascade do |t|
    t.string   "pincode"
    t.integer  "total_orders",      precision: 38
    t.decimal  "total_value"
    t.datetime "last_ran_on"
    t.text     "description"
    t.integer  "courier_id",        precision: 38
    t.integer  "time_to_deliver",   precision: 38
    t.integer  "cod_avail",         precision: 38
    t.integer  "distributor_avail", precision: 38
    t.integer  "paid_order",        precision: 38
    t.decimal  "paid_value"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "product_active_codes", force: :cascade do |t|
    t.string   "name"
    t.integer  "sortorder",  precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string   "name"
    t.decimal  "vatpercent"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_cost_masters", force: :cascade do |t|
    t.integer  "product_id",              precision: 38
    t.integer  "product_list_id",         precision: 38
    t.string   "prod"
    t.string   "barcode"
    t.integer  "product_cost",            precision: 38
    t.integer  "basic_cost",              precision: 38
    t.integer  "shipping_handling",       precision: 38
    t.integer  "postage",                 precision: 38
    t.integer  "tel_cost",                precision: 38
    t.integer  "transf_order_basic",      precision: 38
    t.integer  "dealer_network_basic",    precision: 38
    t.integer  "wholesale_variable_cost", precision: 38
    t.integer  "royalty",                 precision: 38
    t.integer  "cost_of_return",          precision: 38
    t.integer  "call_centre_commission",  precision: 38
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "cost",                    precision: 38
    t.integer  "revenue",                 precision: 38
    t.integer  "packaging_cost",          precision: 38
    t.integer  "product_variant_id",      precision: 38
  end

  add_index "product_cost_masters", ["barcode"], name: "i_product_cost_masters_barcode"
  add_index "product_cost_masters", ["prod"], name: "i_product_cost_masters_prod"
  add_index "product_cost_masters", ["product_id"], name: "i_pro_cos_mas_pro_id"
  add_index "product_cost_masters", ["product_list_id"], name: "i_pro_cos_mas_pro_lis_id"
  add_index "product_cost_masters", ["product_variant_id"], name: "i_pro_cos_mas_pro_var_id"

  create_table "product_inventory_codes", force: :cascade do |t|
    t.string   "name"
    t.integer  "sortorder",  precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_lists", force: :cascade do |t|
    t.integer  "product_variant_id",               precision: 38
    t.integer  "product_spec_list_id",             precision: 38
    t.string   "extproductcode"
    t.string   "list_barcode"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "active_status_id",                 precision: 38
    t.string   "name"
    t.integer  "product_master_id",                precision: 38
    t.boolean  "replace_main_product", limit: nil
  end

  add_index "product_lists", ["extproductcode"], name: "i_product_lists_extproductcode"
  add_index "product_lists", ["list_barcode"], name: "i_product_lists_list_barcode"
  add_index "product_lists", ["name"], name: "index_product_lists_on_name"
  add_index "product_lists", ["product_master_id"], name: "i_pro_lis_pro_mas_id"
  add_index "product_lists", ["product_spec_list_id"], name: "i_pro_lis_pro_spe_lis_id"
  add_index "product_lists", ["product_variant_id"], name: "i_pro_lis_pro_var_id"

  create_table "product_master_add_ons", force: :cascade do |t|
    t.integer  "product_master_id",     precision: 38
    t.integer  "product_list_id",       precision: 38
    t.integer  "activeid",              precision: 38
    t.integer  "change_price",          precision: 38
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "sort_order",            precision: 38
    t.integer  "replace_by_product_id", precision: 38
  end

  create_table "product_master_images", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "sort_order",         precision: 38
    t.integer  "product_master_id",  precision: 38
    t.string   "prod"
    t.string   "barcode"
    t.integer  "product_variant_id", precision: 38
    t.integer  "product_list_id",    precision: 38
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "product_master_images", ["barcode"], name: "i_pro_mas_ima_bar"
  add_index "product_master_images", ["name"], name: "i_product_master_images_name"
  add_index "product_master_images", ["prod"], name: "i_product_master_images_prod"
  add_index "product_master_images", ["product_list_id"], name: "i_pro_mas_ima_pro_lis_id"
  add_index "product_master_images", ["product_master_id"], name: "i_pro_mas_ima_pro_mas_id"
  add_index "product_master_images", ["product_variant_id"], name: "i_pro_mas_ima_pro_var_id"

  create_table "product_master_ons", force: :cascade do |t|
    t.integer  "product_master_id", precision: 38
    t.integer  "product_list_id",   precision: 38
    t.integer  "activeid",          precision: 38
    t.integer  "change_price",      precision: 38
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "product_masters", force: :cascade do |t|
    t.string   "name"
    t.integer  "productcategoryid",      precision: 38
    t.integer  "productinventorycodeid", precision: 38
    t.string   "barcode"
    t.decimal  "price"
    t.decimal  "taxes"
    t.decimal  "total"
    t.string   "extproductcode"
    t.text     "description"
    t.integer  "productactivecodeid",    precision: 38
    t.decimal  "costprice"
    t.decimal  "costtaxes"
    t.decimal  "costtotal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "shipping"
    t.integer  "product_sell_type_id",   precision: 38
    t.decimal  "weight_kg",              precision: 8,  scale: 4
    t.integer  "sel_cod",                precision: 38
    t.integer  "sel_s_tax",              precision: 38
    t.integer  "sel_m_cod",              precision: 38
    t.integer  "sel_m_cc",               precision: 38
    t.integer  "sel_cc",                 precision: 38
    t.integer  "tax_id",                 precision: 38
  end

  add_index "product_masters", ["extproductcode"], name: "i_pro_mas_ext"

  create_table "product_sample_stocks", force: :cascade do |t|
    t.integer  "product_master_id", precision: 38
    t.integer  "product_list_id",   precision: 38
    t.string   "product_name"
    t.string   "prod_code"
    t.string   "barcode"
    t.decimal  "basic_price"
    t.decimal  "shipping"
    t.datetime "air_date"
    t.integer  "orders",            precision: 38
    t.integer  "stock",             precision: 38
    t.text     "description"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "product_sell_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "product_spec_lists", force: :cascade do |t|
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

  create_table "product_stock_adjusts", force: :cascade do |t|
    t.integer  "product_master_id", precision: 38
    t.integer  "product_list_id",   precision: 38
    t.integer  "change_stock",      precision: 38
    t.string   "ext_prod_code"
    t.string   "barcode"
    t.datetime "created_date"
    t.string   "emp_code"
    t.integer  "emp_id",            precision: 38
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "total",             precision: 38
    t.integer  "rate",              precision: 38
  end

  create_table "product_stock_books", force: :cascade do |t|
    t.datetime "stock_date"
    t.integer  "product_master_id",        precision: 38
    t.integer  "product_list_id",          precision: 38
    t.string   "ext_prod_code"
    t.string   "name"
    t.integer  "opening_qty",              precision: 38
    t.integer  "opening_rate",             precision: 38
    t.integer  "opening_value",            precision: 38
    t.integer  "purchased_qty",            precision: 38
    t.integer  "purchased_rate",           precision: 38
    t.integer  "purchased_value",          precision: 38
    t.integer  "returned_retail_qty",      precision: 38
    t.integer  "returned_retail_rate",     precision: 38
    t.integer  "returned_retail_value",    precision: 38
    t.integer  "returned_wholesale_qty",   precision: 38
    t.integer  "returned_wholesale_rate",  precision: 38
    t.integer  "returned_wholesale_value", precision: 38
    t.integer  "returned_others_qty",      precision: 38
    t.integer  "returned_others_rate",     precision: 38
    t.integer  "returned_others_value",    precision: 38
    t.integer  "sold_retail_qty",          precision: 38
    t.integer  "sold_retail_rate",         precision: 38
    t.integer  "sold_retail_value",        precision: 38
    t.integer  "sold_wholesale",           precision: 38
    t.integer  "sold_wholesale_rate",      precision: 38
    t.integer  "sold_wholesale_value",     precision: 38
    t.integer  "sold_branch_qty",          precision: 38
    t.integer  "sold_branch_rate",         precision: 38
    t.integer  "sold_branch_value",        precision: 38
    t.integer  "corrections_qty",          precision: 38
    t.integer  "corrections_rate",         precision: 38
    t.integer  "corrections_value",        precision: 38
    t.integer  "closing_qty",              precision: 38
    t.integer  "closing_rate",             precision: 38
    t.integer  "closing_value",            precision: 38
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "list_barcode"
  end

  add_index "product_stock_books", ["ext_prod_code"], name: "i_pro_sto_boo_ext_pro_cod"
  add_index "product_stock_books", ["list_barcode"], name: "i_pro_sto_boo_lis_bar"
  add_index "product_stock_books", ["product_list_id"], name: "i_pro_sto_boo_pro_lis_id"
  add_index "product_stock_books", ["product_master_id"], name: "i_pro_sto_boo_pro_mas_id"
  add_index "product_stock_books", ["stock_date"], name: "i_pro_sto_boo_sto_dat"

  create_table "product_stocks", force: :cascade do |t|
    t.integer  "product_master_id", precision: 38
    t.integer  "product_list_id",   precision: 38
    t.integer  "current_stock",     precision: 38
    t.string   "ext_prod_code"
    t.string   "barcode"
    t.datetime "checked_date"
    t.string   "emp_code"
    t.integer  "emp_id",            precision: 38
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "product_test_ppos", force: :cascade do |t|
    t.string   "name"
    t.string   "prod_code"
    t.string   "barcode"
    t.decimal  "basic_price"
    t.decimal  "shipping"
    t.string   "channel"
    t.datetime "aired_date"
    t.string   "slot"
    t.integer  "orders",      precision: 38
    t.decimal  "ppo"
    t.decimal  "ad_cost"
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "product_training_headings", force: :cascade do |t|
    t.string   "name"
    t.integer  "sortorder",  precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_training_manuals", force: :cascade do |t|
    t.integer  "productid",                   precision: 38
    t.string   "name"
    t.text     "description"
    t.text     "quicknotes"
    t.integer  "product_training_heading_id", precision: 38
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_variants", force: :cascade do |t|
    t.string   "name"
    t.integer  "productmasterid",      precision: 38
    t.string   "variantbarcode"
    t.decimal  "price"
    t.decimal  "taxes"
    t.decimal  "total"
    t.string   "extproductcode"
    t.text     "description"
    t.integer  "activeid",             precision: 38
    t.decimal  "shipping"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_sell_type_id", precision: 38
  end

  add_index "product_variants", ["activeid"], name: "i_product_variants_activeid"
  add_index "product_variants", ["extproductcode"], name: "i_pro_var_ext"
  add_index "product_variants", ["product_sell_type_id"], name: "i_pro_var_pro_sel_typ_id"
  add_index "product_variants", ["productmasterid"], name: "i_pro_var_pro"
  add_index "product_variants", ["variantbarcode"], name: "i_pro_var_var"

  create_table "product_warehouses", force: :cascade do |t|
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

  create_table "promotions", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "start_hr",             precision: 38
    t.integer  "start_min",            precision: 38
    t.integer  "end_hr",               precision: 38
    t.integer  "end_min",              precision: 38
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "media_id",             precision: 38
    t.integer  "min_sale_value",       precision: 38
    t.decimal  "discount_percent",     precision: 4,  scale: 4
    t.integer  "discount_value",       precision: 38
    t.integer  "free_product_list_id", precision: 38
    t.integer  "active",               precision: 38
    t.string   "unique_code"
    t.decimal  "promo_cost",           precision: 12, scale: 2
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "registration_statuses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "sort_order",  precision: 38
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "regusers", id: false, force: :cascade do |t|
    t.decimal "userid",                                null: false
    t.string  "username",   limit: 100
    t.string  "password",   limit: 100
    t.string  "channel",    limit: 50
    t.string  "dept",       limit: 50
    t.integer "commission", limit: 18,  precision: 18
    t.string  "media",      limit: 1
    t.string  "cdm",        limit: 50
    t.string  "telnum",     limit: 50
    t.string  "upd",        limit: 1
    t.string  "city",       limit: 50
    t.string  "district",   limit: 50
  end

  create_table "return_rates", force: :cascade do |t|
    t.string   "name"
    t.integer  "sort_order",         precision: 38
    t.integer  "total",              precision: 38
    t.integer  "cancelled",          precision: 38
    t.integer  "returned",           precision: 38
    t.integer  "paid",               precision: 38
    t.integer  "transfer_total",     precision: 38
    t.integer  "transfer_paid",      precision: 38
    t.integer  "transfer_cancelled", precision: 38
    t.integer  "no_of_days",         precision: 38
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "shipped",            precision: 38
    t.integer  "offset",             precision: 38
    t.integer  "media_id",           precision: 38
    t.integer  "product_master_id",  precision: 38
    t.integer  "product_variant_id", precision: 38
    t.integer  "product_list_id",    precision: 38
    t.string   "ext_prod_code"
  end

  add_index "return_rates", ["ext_prod_code"], name: "i_return_rates_ext_prod_code"
  add_index "return_rates", ["media_id"], name: "index_return_rates_on_media_id"
  add_index "return_rates", ["name"], name: "index_return_rates_on_name"
  add_index "return_rates", ["no_of_days"], name: "i_return_rates_no_of_days"
  add_index "return_rates", ["offset"], name: "index_return_rates_on_offset"
  add_index "return_rates", ["product_list_id"], name: "i_return_rates_product_list_id"
  add_index "return_rates", ["product_master_id"], name: "i_ret_rat_pro_mas_id"
  add_index "return_rates", ["product_variant_id"], name: "i_ret_rat_pro_var_id"

  create_table "sales_incentives", force: :cascade do |t|
    t.string   "name"
    t.decimal  "min_value",   precision: 6,  scale: 4
    t.decimal  "max_value",   precision: 6,  scale: 4
    t.decimal  "commission",  precision: 6,  scale: 4
    t.integer  "no_of",       precision: 38
    t.text     "description"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "sales_ppo_defaults", force: :cascade do |t|
    t.string   "name"
    t.decimal  "value",       precision: 5, scale: 2
    t.text     "description"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "sales_ppo_email_alerts", force: :cascade do |t|
    t.string   "email_id"
    t.datetime "last_delivered_on"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "sales_ppo_product_alerts", force: :cascade do |t|
    t.integer  "product_list_id", precision: 38
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "sales_ppos", force: :cascade do |t|
    t.integer  "campaign_playlist_id",        precision: 38
    t.integer  "campaign_id",                 precision: 38
    t.integer  "product_master_id",           precision: 38
    t.integer  "product_variant_id",          precision: 38
    t.integer  "product_list_id",             precision: 38
    t.string   "prod"
    t.string   "name"
    t.datetime "start_time"
    t.integer  "order_id",                    precision: 38
    t.integer  "order_line_id",               precision: 38
    t.integer  "product_cost",                precision: 38
    t.integer  "pieces",                      precision: 38
    t.integer  "revenue",                     precision: 38
    t.integer  "damages",                     precision: 38
    t.integer  "returns",                     precision: 38
    t.integer  "commission_cost",             precision: 38
    t.integer  "promotion_cost",              precision: 38
    t.integer  "gross_sales",                 precision: 38
    t.integer  "net_sale",                    precision: 38
    t.integer  "external_order_no",           precision: 38
    t.integer  "order_status_id",             precision: 38
    t.integer  "order_last_mile_id",          precision: 38
    t.string   "order_pincode"
    t.integer  "media_id",                    precision: 38
    t.integer  "promo_cost_total",            precision: 38
    t.string   "dnis"
    t.string   "city"
    t.string   "state"
    t.string   "mobile_no"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "shipping_cost",               precision: 38
    t.integer  "transfer_order_revenue",      precision: 38
    t.integer  "transfer_order_dealer_price", precision: 38
    t.decimal  "commission_on_order",         precision: 14, scale: 4
    t.integer  "payment_cost",                precision: 38
  end

  add_index "sales_ppos", ["campaign_id"], name: "i_sales_ppos_campaign_id"
  add_index "sales_ppos", ["campaign_playlist_id"], name: "i_sal_ppo_cam_pla_id"
  add_index "sales_ppos", ["city"], name: "index_sales_ppos_on_city"
  add_index "sales_ppos", ["external_order_no"], name: "i_sales_ppos_external_order_no"
  add_index "sales_ppos", ["media_id"], name: "index_sales_ppos_on_media_id"
  add_index "sales_ppos", ["order_id"], name: "index_sales_ppos_on_order_id"
  add_index "sales_ppos", ["order_last_mile_id"], name: "i_sal_ppo_ord_las_mil_id"
  add_index "sales_ppos", ["order_line_id"], name: "i_sales_ppos_order_line_id"
  add_index "sales_ppos", ["order_pincode"], name: "i_sales_ppos_order_pincode"
  add_index "sales_ppos", ["order_status_id"], name: "i_sales_ppos_order_status_id"
  add_index "sales_ppos", ["prod"], name: "index_sales_ppos_on_prod"
  add_index "sales_ppos", ["product_list_id"], name: "i_sales_ppos_product_list_id"
  add_index "sales_ppos", ["product_master_id"], name: "i_sales_ppos_product_master_id"
  add_index "sales_ppos", ["product_variant_id"], name: "i_sal_ppo_pro_var_id"
  add_index "sales_ppos", ["state"], name: "index_sales_ppos_on_state"

  create_table "sales_report_pay_u_steps", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "min_value",               precision: 38
    t.integer  "max_value",               precision: 38
    t.boolean  "active",      limit: nil
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "sales_upsale_products", force: :cascade do |t|
    t.integer  "product_list_id", precision: 38
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "sales_upsale_products", ["product_list_id"], name: "i_sal_ups_pro_pro_lis_id", unique: true

  create_table "salutes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sequence_check", id: false, force: :cascade do |t|
    t.integer "ordernum",      limit: 10, precision: 10
    t.string  "customer_name", limit: 50
    t.string  "city",          limit: 50
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "employee_code"
    t.string   "emailid"
    t.string   "userip"
    t.string   "sessionid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_code"
  end

  add_index "states", ["short_code"], name: "index_states_on_short_code"

  create_table "tax_rates", force: :cascade do |t|
    t.string   "name"
    t.decimal  "tax_rate",                 precision: 6,  scale: 5
    t.decimal  "reverse_rate",             precision: 10, scale: 9
    t.text     "description"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "is_external",  limit: nil
  end

  create_table "temp_test_emp", primary_key: "temp_test_emp_id", force: :cascade do |t|
    t.string "data_text", limit: 50
    t.string "date_more", limit: 50
  end

  create_table "transfer_order_lines", force: :cascade do |t|
    t.integer  "transfer_order_id",        precision: 38
    t.string   "prod"
    t.text     "description"
    t.integer  "product_list_id",          precision: 38
    t.integer  "product_variant_id",       precision: 38
    t.integer  "product_master_id",        precision: 38
    t.integer  "pieces",                   precision: 38
    t.integer  "sub_total",                precision: 38
    t.integer  "shipping",                 precision: 38
    t.integer  "codcharges",               precision: 38
    t.integer  "total",                    precision: 38
    t.integer  "transfer_order_status_id", precision: 38
    t.text     "notes"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "transfer_order_masters", force: :cascade do |t|
    t.integer  "corporate_id",             precision: 38
    t.datetime "orderdate"
    t.integer  "customer_id",              precision: 38
    t.integer  "order_id",                 precision: 38
    t.integer  "order_no",                 precision: 38
    t.string   "customer_name"
    t.string   "mobile"
    t.string   "email"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "landmark"
    t.string   "district"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "pincode"
    t.string   "phone1"
    t.string   "phone2"
    t.integer  "pieces",                   precision: 38
    t.integer  "sub_total",                precision: 38
    t.integer  "shipping",                 precision: 38
    t.integer  "codcharges",               precision: 38
    t.integer  "total",                    precision: 38
    t.integer  "g_total",                  precision: 38
    t.integer  "transfer_order_status_id", precision: 38
    t.text     "notes"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "transfer_order_statuses", force: :cascade do |t|
    t.string   "name"
    t.integer  "sort_order",  precision: 38
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "user_names", force: :cascade do |t|
    t.string   "name"
    t.string   "company_name"
    t.text     "description"
    t.boolean  "approved",     limit: nil
    t.string   "password"
    t.string   "emailid"
    t.string   "mobile"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "employee_code"
    t.integer  "role",            precision: 38
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["employee_code"], name: "index_users_on_employee_code", unique: true

  create_table "vpp_deal_trans", force: :cascade do |t|
    t.datetime "actdate"
    t.string   "action",                limit: 10
    t.string   "add1",                  limit: 40
    t.string   "add2",                  limit: 40
    t.string   "add3",                  limit: 40
    t.string   "barcode",               limit: 25
    t.string   "barcode2",              limit: 25
    t.string   "barcode3",              limit: 25
    t.decimal  "basicprice",                        precision: 8,  scale: 2
    t.string   "cfo",                   limit: 1
    t.integer  "channel",               limit: 3,   precision: 3
    t.string   "city",                  limit: 20
    t.datetime "claimdate"
    t.decimal  "codamt",                            precision: 8,  scale: 2
    t.decimal  "convcharges",                       precision: 8,  scale: 2
    t.string   "cou",                   limit: 1
    t.integer  "custref",               limit: 12,  precision: 12
    t.integer  "debitnote",             limit: 5,   precision: 5
    t.datetime "debitnotedate"
    t.datetime "delvdate"
    t.string   "deo",                   limit: 10
    t.string   "dept",                  limit: 20
    t.string   "despatch",              limit: 3
    t.string   "dist",                  limit: 1
    t.integer  "distcode",              limit: 10,  precision: 10
    t.string   "distname",              limit: 50
    t.string   "dt_hour",               limit: 2
    t.string   "dt_min",                limit: 2
    t.string   "email",                 limit: 30
    t.string   "emi",                   limit: 5
    t.datetime "entrydate"
    t.string   "fax",                   limit: 20
    t.string   "fname",                 limit: 30
    t.datetime "invdate"
    t.string   "fsize",                 limit: 1
    t.string   "invoice",               limit: 10
    t.decimal  "invoiceamount",                     precision: 8,  scale: 2
    t.string   "landmark",              limit: 30
    t.boolean  "letter",                limit: nil
    t.string   "lessprod",              limit: 6
    t.string   "lname",                 limit: 30
    t.datetime "loydate"
    t.string   "manifest",              limit: 8
    t.string   "modby",                 limit: 10
    t.datetime "moddt"
    t.boolean  "notice",                limit: nil
    t.integer  "normal",                limit: 6,   precision: 6
    t.integer  "operator",              limit: 3,   precision: 3
    t.string   "order_number",          limit: 15
    t.datetime "orderdate"
    t.string   "orderno",               limit: 15
    t.string   "ordersource",           limit: 1
    t.integer  "paidamt",               limit: 6,   precision: 6
    t.datetime "paiddate"
    t.string   "ordertype",             limit: 1
    t.integer  "pin",                   limit: 6,   precision: 6
    t.integer  "postage",               limit: 5,   precision: 5
    t.datetime "probag"
    t.string   "prod",                  limit: 6
    t.integer  "qty",                   limit: 2,   precision: 2
    t.string   "remarks",               limit: 1
    t.integer  "refundamt",             limit: 5,   precision: 5
    t.string   "refundcheck",           limit: 10
    t.datetime "refundcheckdate"
    t.datetime "refunddate"
    t.datetime "returndate"
    t.integer  "sanction",              limit: 5,   precision: 5
    t.datetime "shdate"
    t.boolean  "shipped",               limit: nil
    t.string   "state",                 limit: 3
    t.string   "status",                limit: 20
    t.datetime "statusdate"
    t.integer  "taxamt",                limit: 5,   precision: 5
    t.decimal  "taxper",                            precision: 5,  scale: 2
    t.string   "tel1",                  limit: 20
    t.string   "tel2",                  limit: 20
    t.string   "tempstatus",            limit: 1
    t.datetime "tempstatusdate"
    t.datetime "temptrandate"
    t.string   "title",                 limit: 3
    t.datetime "trandate"
    t.string   "transfer",              limit: 1
    t.string   "trantype",              limit: 1
    t.boolean  "vpp",                   limit: nil
    t.decimal  "weight",                            precision: 6,  scale: 2
    t.integer  "invoicerefno",          limit: 12,  precision: 12
    t.text     "description"
    t.integer  "order_last_mile_id",                precision: 38
    t.integer  "order_final_status_id", limit: 6,   precision: 6
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  create_table "vpp_tables", force: :cascade do |t|
  end

  create_table "vpp_test", id: false, force: :cascade do |t|
    t.integer "asd", limit: 5, precision: 5
  end

  create_table "vpps", force: :cascade do |t|
    t.datetime "orderdate"
    t.datetime "entrydate"
    t.string   "ordersource"
    t.string   "despatch"
    t.string   "prod"
    t.string   "trantype"
    t.string   "title"
    t.string   "lname"
    t.string   "fname"
    t.string   "add1"
    t.string   "add2"
    t.string   "add3"
    t.string   "city"
    t.integer  "pincode",         precision: 38
    t.string   "tel1"
    t.string   "tel2"
    t.string   "fax"
    t.string   "email"
    t.string   "dept"
    t.integer  "basic",           precision: 38
    t.integer  "postage",         precision: 38
    t.decimal  "taxper",          precision: 5,  scale: 2
    t.integer  "taxamt",          precision: 38
    t.string   "manifest"
    t.string   "invoice"
    t.datetime "shdate"
    t.integer  "invoiceamount",   precision: 38
    t.datetime "paiddate"
    t.datetime "returndate"
    t.datetime "refunddate"
    t.string   "refundchek"
    t.datetime "refundcheckdate"
    t.string   "cfo"
    t.integer  "operator",        precision: 38
    t.integer  "shipped",         precision: 38
    t.integer  "paidamt",         precision: 38
    t.integer  "refundamt",       precision: 38
    t.string   "dist"
    t.string   "state"
    t.integer  "letter",          precision: 38
    t.string   "deo"
    t.string   "modby"
    t.datetime "moddt"
    t.string   "cou"
    t.datetime "probag"
    t.integer  "notice",          precision: 38
    t.string   "transfer"
    t.string   "reason"
    t.string   "orderno"
    t.datetime "claimdate"
    t.datetime "delvdate"
    t.integer  "channel",         precision: 38
    t.string   "fsize"
    t.integer  "custref",         precision: 38
    t.integer  "sanction",        precision: 38
    t.string   "emi"
    t.datetime "trandate"
    t.string   "status"
    t.datetime "statusdate"
    t.string   "landmark"
    t.string   "barcode"
    t.string   "barcode2"
    t.string   "barcode3"
    t.string   "order_number"
    t.integer  "codamt",          precision: 38
    t.decimal  "weight",          precision: 10, scale: 2
    t.string   "dt_hour"
    t.string   "dt_min"
    t.integer  "convcharges",     precision: 38
  end

  add_foreign_key "cust_details_tracks", "order_masters"
end
