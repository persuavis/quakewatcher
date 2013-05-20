require 'spec_helper'

describe Api::EarthquakesController do

  let(:earthquake) { Earthquake.create!(
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

  describe "GET 'list'" do
    it "returns http success" do
      get 'list'
      response.should be_success
    end

    it "shows a list of recent earthquakes" do
      get 'list'
      assigns[:earthquakes].should_not be_nil
    end

  end

end
