FactoryGirl.define do
  factory :earthquake do
    src       'ak'
    #eqid      '10720478'
    sequence(:eqid) {|n| "eqid_#{n}" }
    version   '1'
    datetime  "Monday, May 20, 2013 03:45:21 UTC"
    lat       63.1302
    lon       -149.8962
    magnitude 1.4
    depth     92.90
    nst       10
    region    "Central Alaska"
    raw       { "ak,#{eqid},1,\"Monday, May 20, 2013 03:45:21 UTC\",63.1302,-149.8962,1.4,92.90,10,\"Central Alaska\"" }
    #created_at
    #updated_at
  end
end

    #t.string   "src"
    #t.string   "eqid",                                     :null => false
    #t.string   "version"
    #t.datetime "datetime"
    #t.decimal  "lat",        :precision => 8, :scale => 5
    #t.decimal  "lon",        :precision => 8, :scale => 5
    #t.float    "magnitude"
    #t.float    "depth"
    #t.integer  "nst"
    #t.string   "region"
    #t.text     "raw"
    #t.datetime "created_at",                               :null => false
    #t.datetime "updated_at",                               :null => false
