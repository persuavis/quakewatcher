class Earthquake < ActiveRecord::Base
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

  # any scopes should go here:
  # ...

  def self.search(options)
    options ||= {}
    result = Earthquake.where(true)
    result = result.on(options[:on]) if options[:on]
    result = result.since(options[:since]) if options[:since]
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
