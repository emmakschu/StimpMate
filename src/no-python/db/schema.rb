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

ActiveRecord::Schema.define(version: 20170515094713) do

  create_table "stimps", force: :cascade do |t|
    t.string   "course",     limit: 32
    t.string   "soilType",   limit: 32
    t.string   "green",      limit: 32
    t.string   "mower",      limit: 32
    t.string   "roller",     limit: 32
    t.integer  "forward1",   limit: 4
    t.integer  "forward2",   limit: 4
    t.integer  "forward3",   limit: 4
    t.integer  "backward1",  limit: 4
    t.integer  "backward2",  limit: 4
    t.integer  "backward3",  limit: 4
    t.integer  "left1",      limit: 4
    t.integer  "left2",      limit: 4
    t.integer  "left3",      limit: 4
    t.integer  "right1",     limit: 4
    t.integer  "right2",     limit: 4
    t.integer  "right3",     limit: 4
    t.float    "raw_speed",  limit: 53
    t.float    "adj_speed",  limit: 53
    t.float    "std_dev",    limit: 53
    t.text     "notes",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "weather",    limit: 65535
    t.boolean  "verticut"
    t.integer  "entries",    limit: 4
  end

end
