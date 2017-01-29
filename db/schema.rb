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

ActiveRecord::Schema.define(version: 20170129115108) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "title",      null: false
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id", "title"], name: "index_categories_on_parent_id_and_title", unique: true, using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.integer  "user_id",                        null: false
    t.string   "form",       default: "company", null: false
    t.string   "inn",                            null: false
    t.string   "name",                           null: false
    t.string   "ogrn",                           null: false
    t.string   "charter"
    t.string   "order"
    t.string   "decision"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["user_id", "inn"], name: "index_companies_on_user_id_and_inn", unique: true, using: :btree
    t.index ["user_id"], name: "index_companies_on_user_id", using: :btree
  end

  create_table "goods", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "category_id"
    t.integer  "state_cd",    default: 0, null: false
    t.string   "title",                   null: false
    t.text     "details"
    t.decimal  "price"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["category_id"], name: "index_goods_on_category_id", using: :btree
    t.index ["company_id"], name: "index_goods_on_company_id", using: :btree
  end

  create_table "passport_images", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "image",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_passport_images_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                                       null: false
    t.string   "phone"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at", using: :btree
    t.index ["phone"], name: "index_users_on_phone", unique: true, using: :btree
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", using: :btree
  end

  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "goods", "categories"
  add_foreign_key "goods", "companies"
  add_foreign_key "passport_images", "users"
end
