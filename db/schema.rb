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

ActiveRecord::Schema.define(version: 20140627172545) do

  create_table "accounts", force: true do |t|
    t.boolean  "hipchat_installed"
    t.string   "hipchat_oauth_id"
    t.string   "hipchat_oauth_secret"
    t.datetime "hipchat_oauth_issued_at"
    t.string   "hipchat_oauth_token"
    t.string   "hipchat_user_id"
    t.string   "hipchat_config_context"
    t.string   "hipchat_capabilities_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
