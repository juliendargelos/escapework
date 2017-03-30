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

ActiveRecord::Schema.define(version: 20170330091046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "problem_id", null: false
    t.string   "content",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_answers_on_problem_id", using: :btree
    t.index ["user_id"], name: "index_answers_on_user_id", using: :btree
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "workshop_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_participations_on_user_id", using: :btree
    t.index ["workshop_id"], name: "index_participations_on_workshop_id", using: :btree
  end

  create_table "problems", force: :cascade do |t|
    t.integer  "workshop_id",             null: false
    t.text     "content",                 null: false
    t.string   "solution",                null: false
    t.integer  "kind",        default: 1, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["workshop_id"], name: "index_problems_on_workshop_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string  "email",                       null: false
    t.string  "password_digest",             null: false
    t.string  "firstname",                   null: false
    t.string  "lastname",                    null: false
    t.integer "status",          default: 1, null: false
  end

  create_table "workshops", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answers", "problems"
  add_foreign_key "answers", "users"
  add_foreign_key "participations", "users"
  add_foreign_key "participations", "workshops"
  add_foreign_key "problems", "workshops"
end
