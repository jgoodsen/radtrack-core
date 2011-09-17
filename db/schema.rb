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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100620002234) do

  create_table "boards", :force => true do |t|
    t.string   "name"
    t.text     "card_positions_json"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "card_states", :force => true do |t|
    t.integer  "position",   :default => 1
    t.string   "name",                      :null => false
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wip_limit",  :default => 0
  end

  create_table "card_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "status"
    t.integer  "point_estimate", :default => 0
    t.integer  "position",       :default => 0
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "card_type_id",   :default => 2
    t.integer  "card_state_id"
    t.integer  "user_id"
  end

  add_index "cards", ["user_id"], :name => "index_cards_on_user_id"

  create_table "project_assignments", :force => true do |t|
    t.integer "user_id"
    t.integer "project_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_states", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.integer  "position",      :default => 0
    t.integer  "task_state_id",                :null => false
    t.integer  "card_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "persistence_token"
    t.string   "perishable_token",                         :default => "", :null => false
    t.integer  "login_count",                              :default => 0,  :null => false
    t.integer  "failed_login_count",                       :default => 0,  :null => false
    t.datetime "current_login_at"
    t.string   "current_login_ip"
    t.datetime "last_login_at"
    t.string   "last_login_ip"
    t.string   "crypted_password",          :limit => 128, :default => "", :null => false
    t.string   "salt",                      :limit => 128, :default => "", :null => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
