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

ActiveRecord::Schema.define(version: 20170228084101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "banners", force: :cascade do |t|
    t.string   "subject",                    null: false
    t.text     "text"
    t.boolean  "is_active",  default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title",                   null: false
    t.integer  "parent_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "goods_count", default: 0, null: false
    t.index ["parent_id", "title"], name: "index_categories_on_parent_id_and_title", unique: true, using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.integer  "user_id",                                null: false
    t.string   "form",               default: "company", null: false
    t.string   "name",                                   null: false
    t.string   "ogrn",                                   null: false
    t.string   "inn",                                    null: false
    t.string   "kpp"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.uuid     "account_id",                             null: false
    t.string   "workflow_state"
    t.text     "reject_message"
    t.string   "short_name"
    t.string   "management_post"
    t.string   "management_name"
    t.string   "address"
    t.string   "phone"
    t.integer  "documents_count",    default: 0,         null: false
    t.integer  "goods_count",        default: 0,         null: false
    t.string   "email"
    t.uuid     "locked_account_id"
    t.datetime "awaiting_review_at"
    t.datetime "being_reviewed_at"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.integer  "moderator_id"
    t.index ["account_id"], name: "index_companies_on_account_id", unique: true, using: :btree
    t.index ["user_id", "inn"], name: "index_companies_on_user_id_and_inn", unique: true, using: :btree
    t.index ["user_id"], name: "index_companies_on_user_id", using: :btree
  end

  create_table "company_documents", force: :cascade do |t|
    t.integer  "company_id",   null: false
    t.string   "file",         null: false
    t.string   "state",        null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "category",     null: false
    t.bigint   "file_size"
    t.string   "content_type"
    t.index ["company_id", "category"], name: "index_company_documents_on_company_id_and_category", using: :btree
    t.index ["company_id"], name: "index_company_documents_on_company_id", using: :btree
  end

  create_table "good_images", force: :cascade do |t|
    t.integer  "good_id",      null: false
    t.string   "image",        null: false
    t.bigint   "file_size",    null: false
    t.string   "content_type", null: false
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["good_id"], name: "index_good_images_on_good_id", using: :btree
  end

  create_table "goods", force: :cascade do |t|
    t.integer  "company_id",                         null: false
    t.integer  "category_id",                        null: false
    t.integer  "state_cd",            default: 0,    null: false
    t.string   "title",                              null: false
    t.text     "details"
    t.decimal  "price"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "image"
    t.boolean  "prepayment_required", default: true, null: false
    t.index ["category_id"], name: "index_goods_on_category_id", using: :btree
    t.index ["company_id"], name: "index_goods_on_company_id", using: :btree
  end

  create_table "openbill_accounts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "owner_id"
    t.uuid     "category_id",                                           null: false
    t.decimal  "amount_cents",                 default: "0.0",          null: false
    t.string   "amount_currency",    limit: 3, default: "RUB",          null: false
    t.text     "details"
    t.integer  "transactions_count",           default: 0,              null: false
    t.hstore   "meta",                         default: {},             null: false
    t.datetime "created_at",                   default: -> { "now()" }
    t.datetime "updated_at",                   default: -> { "now()" }
    t.index ["created_at"], name: "index_accounts_on_created_at", using: :btree
    t.index ["id"], name: "index_accounts_on_id", unique: true, using: :btree
    t.index ["meta"], name: "index_accounts_on_meta", using: :gin
  end

  create_table "openbill_categories", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid   "owner_id"
    t.string "name",      limit: 256, null: false
    t.uuid   "parent_id"
    t.index ["parent_id", "name"], name: "index_openbill_categories_name", unique: true, using: :btree
  end

  create_table "openbill_lockings", force: :cascade do |t|
    t.integer  "seller_id",                                        null: false
    t.integer  "buyer_id",                                         null: false
    t.integer  "good_id",                                          null: false
    t.uuid     "locking_transaction_id",                           null: false
    t.uuid     "reverse_transaction_id"
    t.uuid     "buy_transaction_id"
    t.string   "workflow_state",                                   null: false
    t.decimal  "amount_cents",                                     null: false
    t.string   "amount_currency",        limit: 3, default: "RUB", null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.index ["buy_transaction_id"], name: "index_openbill_lockings_on_buy_transaction_id", using: :btree
    t.index ["buyer_id"], name: "index_openbill_lockings_on_buyer_id", using: :btree
    t.index ["good_id"], name: "index_openbill_lockings_on_good_id", using: :btree
    t.index ["locking_transaction_id"], name: "index_openbill_lockings_on_locking_transaction_id", using: :btree
    t.index ["reverse_transaction_id"], name: "index_openbill_lockings_on_reverse_transaction_id", using: :btree
    t.index ["seller_id"], name: "index_openbill_lockings_on_seller_id", using: :btree
    t.index ["workflow_state"], name: "index_openbill_lockings_on_workflow_state", using: :btree
  end

  create_table "openbill_operations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at",                  default: -> { "now()" }
    t.uuid     "from_account_id",                                      null: false
    t.uuid     "to_account_id",                                        null: false
    t.uuid     "owner_id"
    t.string   "key",             limit: 256,                          null: false
    t.text     "details",                                              null: false
    t.hstore   "meta",                        default: {},             null: false
  end

  create_table "openbill_policies", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string  "name",             limit: 256,                null: false
    t.uuid    "from_category_id"
    t.uuid    "to_category_id"
    t.uuid    "from_account_id"
    t.uuid    "to_account_id"
    t.boolean "allow_reverse",                default: true, null: false
    t.index ["name"], name: "index_openbill_policies_name", unique: true, using: :btree
  end

  create_table "openbill_transactions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "operation_id"
    t.uuid     "owner_id"
    t.string   "username",               limit: 255,                                        null: false
    t.date     "date",                               default: -> { "('now'::text)::date" }, null: false
    t.datetime "created_at",                         default: -> { "now()" }
    t.uuid     "from_account_id",                                                           null: false
    t.uuid     "to_account_id",                                                             null: false
    t.decimal  "amount_cents",                                                              null: false
    t.string   "amount_currency",        limit: 3,                                          null: false
    t.string   "key",                    limit: 256,                                        null: false
    t.text     "details",                                                                   null: false
    t.hstore   "meta",                               default: {},                           null: false
    t.uuid     "reverse_transaction_id"
    t.index ["created_at"], name: "index_transactions_on_created_at", using: :btree
    t.index ["key"], name: "index_transactions_on_key", unique: true, using: :btree
    t.index ["meta"], name: "index_transactions_on_meta", using: :gin
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "company_id", null: false
    t.integer  "good_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_orders_on_company_id", using: :btree
    t.index ["good_id"], name: "index_orders_on_good_id", using: :btree
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "passport_images", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "image",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_passport_images_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                                             null: false
    t.string   "email",                                            null: false
    t.string   "phone",                                            null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "last_login_from_ip_address"
    t.string   "inn"
    t.integer  "failed_logins_count",             default: 0
    t.datetime "lock_expires_at"
    t.string   "unlock_token"
    t.string   "role",                            default: "user", null: false
    t.integer  "shown_banners",                   default: [],     null: false, array: true
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at", using: :btree
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", using: :btree
  end

  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "companies", "users", column: "moderator_id"
  add_foreign_key "good_images", "goods"
  add_foreign_key "goods", "categories"
  add_foreign_key "goods", "companies"
  add_foreign_key "openbill_accounts", "openbill_categories", column: "category_id", name: "openbill_accounts_category_id_fkey", on_delete: :restrict
  add_foreign_key "openbill_categories", "openbill_categories", column: "parent_id", name: "openbill_categories_parent_id_fkey", on_delete: :restrict
  add_foreign_key "openbill_lockings", "companies", column: "buyer_id"
  add_foreign_key "openbill_lockings", "companies", column: "seller_id"
  add_foreign_key "openbill_lockings", "goods"
  add_foreign_key "openbill_lockings", "openbill_transactions", column: "buy_transaction_id"
  add_foreign_key "openbill_lockings", "openbill_transactions", column: "locking_transaction_id"
  add_foreign_key "openbill_lockings", "openbill_transactions", column: "reverse_transaction_id"
  add_foreign_key "openbill_policies", "openbill_accounts", column: "from_account_id", name: "openbill_policies_from_account_id_fkey"
  add_foreign_key "openbill_policies", "openbill_accounts", column: "to_account_id", name: "openbill_policies_to_account_id_fkey"
  add_foreign_key "openbill_policies", "openbill_categories", column: "from_category_id", name: "openbill_policies_from_category_id_fkey"
  add_foreign_key "openbill_policies", "openbill_categories", column: "to_category_id", name: "openbill_policies_to_category_id_fkey"
  add_foreign_key "openbill_transactions", "openbill_accounts", column: "from_account_id", name: "openbill_transactions_from_account_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "openbill_transactions", "openbill_accounts", column: "to_account_id", name: "openbill_transactions_to_account_id_fkey"
  add_foreign_key "openbill_transactions", "openbill_operations", column: "operation_id", name: "openbill_transactions_operation_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "openbill_transactions", "openbill_transactions", column: "reverse_transaction_id", name: "reverse_transaction_foreign_key"
  add_foreign_key "orders", "companies"
  add_foreign_key "orders", "goods"
  add_foreign_key "orders", "users"
  add_foreign_key "passport_images", "users"
end
