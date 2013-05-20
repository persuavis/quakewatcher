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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130519210335) do

  create_table "earthquakes", :force => true do |t|
    t.string   "src"
    t.string   "eqid",                                     :null => false
    t.string   "version"
    t.datetime "datetime"
    t.decimal  "lat",        :precision => 8, :scale => 5
    t.decimal  "lon",        :precision => 8, :scale => 5
    t.float    "magnitude"
    t.float    "depth"
    t.integer  "nst"
    t.string   "region"
    t.text     "raw"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "earthquakes", ["eqid"], :name => "index_earthquakes_on_eqid", :unique => true

end
