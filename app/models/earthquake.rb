class Earthquake < ActiveRecord::Base
  attr_accessible :datetime, :depth, :eqid, :lat, :lon, :magnitude, :nst, :raw, :region, :src, :version

  validates_uniqueness_of :eqid

end
