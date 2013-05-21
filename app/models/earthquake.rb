class Earthquake < ActiveRecord::Base

  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   #:distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :lon

  attr_accessible :datetime, :depth, :eqid, :lat, :lon, :magnitude, :nst, :raw, :region, :src, :version

  validates_uniqueness_of :eqid

  # any scope-like class methods go here:
  def self.on(datetime_value)
    datetime = convert_datetime(datetime_value)
    midnight = datetime.to_date
    where(:datetime => (midnight)..(midnight + 1.day))
  end

  def self.since(datetime_value)
    datetime = convert_datetime(datetime_value)
    where(["datetime >= ?", datetime])
  end

  def self.over(magnitude)
    where(["magnitude > ?", magnitude])
  end

  def self.near(lat_and_lon)
    lat,lon = lat_and_lon.split(',')
    origin = Earthquake.new(:lat => lat, :lon => lon)
    ids = Earthquake.all.select{|q| origin.distance_from(q) < 5.0 }.collect{|q| q.id}
    where(["id IN (?)", ids])
  end

  # any scopes should go here:
  # ...

  def self.search(options)
    options ||= {}
    result = Earthquake.where(true)
    result = result.on(options[:on]) if options[:on]
    result = result.since(options[:since]) if options[:since]
    result = result.over(options[:over]) if options[:over]
    result = result.near(options[:near]) if options[:near]
    #puts result.to_sql
    result
  end

  def self.convert_datetime(datetime_value)
    case datetime_value
    when Fixnum
      Time.at(datetime_value)
    when String
      Time.at(datetime_value.to_f)
    else
      datetime_value
    end
  end

end
