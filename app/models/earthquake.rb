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
    lat,lon,range = lat_and_lon.split(',')
    range ||= 5
    range = range.to_f
    origin = Earthquake.new(:lat => lat, :lon => lon)
    ids = Earthquake.all.select{|q| origin.distance_from(q) < range }.collect{|q| q.id}
    where(["id IN (?)", ids])
  end

  # any scopes should go here:
  # ...

  def self.search(options)
    options ||= {}
    result = Earthquake.where(true)
    result = result.on(options[:on]) unless options[:on].to_s == ''
    result = result.since(options[:since]) unless options[:since].to_s == ''
    result = result.over(options[:over]) unless options[:over].to_s == ''
    result = result.near(options[:near]) unless options[:near].to_s == ''
    #puts result.to_sql
    result
  end

  def self.convert_datetime(datetime_value)
    case datetime_value
    when Fixnum
      Time.at(datetime_value)
    when String
      self.convert_datetime_string(datetime_value)
      when Float
      Time.at(datetime_value)
    else
      datetime_value
    end
  end

  def self.convert_datetime_string(datetime_string)
    if datetime_string =~ /^\d*$/
      Time.at(datetime_string.to_f)
    elsif datetime_string =~ /^(\d*)\/(\d*)\/(\d*)/
      m = $1; d = $2; y = $3
      Time.new(y, m, d)
    elsif datetime_string =~ /^(\d*)-(\d*)-(\d*)/
      y = $1; m = $2; d = $3
      Time.new(y, m, d)
    else
      raise "invalid datetime string"
    end

  end

  def self.oldest
    Earthquake.order('datetime ASC').first
  end

  def self.newest
    Earthquake.order('datetime ASC').last
  end

end
