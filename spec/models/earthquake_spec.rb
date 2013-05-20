require 'spec_helper'

describe Earthquake do

  let(:earthquake) { Earthquake.new(
      :src => 'us',
      :eqid => 'b000gym1',
      :version => '7',
      :datetime => Time.now.utc, #"Saturday, May 18, 2013 22:39:46 UTC",
      :lat => 52.6720,
      :lon => 158.9419,
      :magnitude => 4.9,
      :depth => 73.80,
      :nst => 134,
      :region => "near the east coast of the Kamchatka Peninsula, Russia"
  )}

  it "should have a unique earthquake id" do
    eq1 = earthquake.dup
    eq2 = earthquake.dup
    eq1.save!
    lambda {eq2.save!}.should raise_error
  end

  it "should parse and store date_time strings" do
    dt_str = "Saturday, May 18, 2013 22:39:46 UTC"
    eq1 = earthquake.dup
    eq1.datetime = dt_str
    dt = DateTime.parse(dt_str)
    eq1.save!
    eq1.reload.datetime.should == dt
  end
end
