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

ActiveRecord::Schema.define(version: 2021_08_08_054319) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "github_accounts", force: :cascade do |t|
    t.string "token", null: false
    t.jsonb "metadata", default: {}
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_github_accounts_on_user_id"
  end

  create_table "github_hooks", force: :cascade do |t|
    t.bigint "github_repository_monitoring_configuration_id", null: false
    t.integer "github_id", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["github_repository_monitoring_configuration_id"], name: "index_gh_hooks_on_gh_monitoring_configuration_id"
  end

  create_table "github_repositories", force: :cascade do |t|
    t.integer "github_id", null: false
    t.string "name", null: false
    t.bigint "github_account_id", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "monitoring_notifications", default: false, null: false, comment: "Indicates whether notifications are being monitored for this repository\n"
    t.index ["github_account_id"], name: "index_github_repositories_on_github_account_id"
  end

  create_table "github_repository_monitoring_configurations", force: :cascade do |t|
    t.bigint "github_repository_id", null: false
    t.text "notification_types", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["github_repository_id"], name: "idx_gh_repository_monitoring_config_on_gh_repository_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.integer "github_id", null: false
    t.string "name", null: false
    t.bigint "github_account_id", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["github_account_id"], name: "index_repositories_on_github_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.citext "email", null: false
    t.string "encrypted_password", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "github_accounts", "users"
  add_foreign_key "github_repositories", "github_accounts"
  add_foreign_key "github_repository_monitoring_configurations", "github_repositories"
  add_foreign_key "repositories", "github_accounts"
end
