# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_01_14_164320) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "lists", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registers", force: :cascade do |t|
    t.text "url"
    t.string "title"
    t.string "description"
    t.string "emails"
    t.string "phones"
    t.string "social_networks"
    t.string "website_url"
    t.string "address"
    t.bigint "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id"], name: "index_registers_on_list_id"
  end

  create_table "sent_emails", force: :cascade do |t|
    t.string "email"
    t.string "subject"
    t.text "body"
    t.string "status"
    t.string "message_id"
    t.bigint "register_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["register_id"], name: "index_sent_emails_on_register_id"
  end

  add_foreign_key "registers", "lists"
  add_foreign_key "sent_emails", "registers"
end
