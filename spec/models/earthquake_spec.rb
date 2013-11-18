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

  describe "search" do
    it "should accept search parameters" do
      search_options = {on: 1364582194}
      lambda {
        Earthquake.search(search_options)
      }.should_not raise_exception
    end

    context "on a specific date" do
      before(:each) do
        @on = 1364582194
        dt = Time.at(@on)
        FactoryGirl.create(:earthquake, :datetime => dt)
        FactoryGirl.create(:earthquake, :datetime => dt + 1.day)
        FactoryGirl.create(:earthquake, :datetime => dt - 1.day)
      end

      it "should accept the search parameter :on as an integer" do
        search_options = {on: @on}
        Earthquake.search(search_options).length.should == 1
      end

      it "should accept the search parameter :on as a float" do
        on_float = @on + 0.5
        search_options = {on: on_float}
        Earthquake.search(search_options).length.should == 1
      end

      it "should accept the search parameter :on as a date string" do
        dt = Time.at(@on)
        on_string = dt.to_s(:db)
        search_options = {on: on_string}
        Earthquake.search(search_options).length.should == 1
      end

      it "should accept the search parameter :on as a date string with slashes" do
        dt = Time.at(@on)
        on_string = "#{dt.month}/#{dt.day}/#{dt.year}"
        search_options = {on: on_string}
        Earthquake.search(search_options).length.should == 1
      end

    end

    context "since a specific date" do
      before(:each) do
        @since = 1364582194
        dt = Time.at(@since)
        FactoryGirl.create(:earthquake, :datetime => dt)
        FactoryGirl.create(:earthquake, :datetime => dt + 1.day)
        FactoryGirl.create(:earthquake, :datetime => dt - 1.day)
      end

      it "should accept the search parameter :since as an integer" do
        search_options = {since: @since}
        Earthquake.search(search_options).length.should == 2
      end

      it "should accept the search parameter :since as a float" do
        on_float = @since + 0.00
        search_options = {since: on_float}
        Earthquake.search(search_options).length.should == 2
      end

      it "should accept the search parameter :since as a date string" do
        dt = Time.at(@since)
        on_string = dt.to_s(:db)
        search_options = {since: on_string}
        Earthquake.search(search_options).length.should == 2
      end

      it "should accept the search parameter :since as a date string with slashes" do
        dt = Time.at(@since)
        on_string = "#{dt.month}/#{dt.day}/#{dt.year}"
        search_options = {since: on_string}
        Earthquake.search(search_options).length.should == 2
      end

    end

    it "should accept the search parameter :over" do
      over = 3.2
      FactoryGirl.create(:earthquake, :magnitude => 1)
      FactoryGirl.create(:earthquake, :magnitude => 2.3)
      FactoryGirl.create(:earthquake, :magnitude => 6.1)
      search_options = {over: over}
      Earthquake.search(search_options).length.should == 1
    end

    it "should accept the search parameter :near" do
      lat, lon = 91, 22
      FactoryGirl.create(:earthquake, :lat => 91.01, :lon => 21.99)
      FactoryGirl.create(:earthquake, :lat => 89, :lon => 50)
      FactoryGirl.create(:earthquake, :lat => -120, :lon => -56)
      search_options = {near: "#{lat},#{lon}"}
      Earthquake.search(search_options).length.should == 1
    end

    it "should accept the search parameter :near with a range" do
      lat, lon = 91, 22
      FactoryGirl.create(:earthquake, :lat => 91.01, :lon => 21.99)
      FactoryGirl.create(:earthquake, :lat => 89, :lon => 23)
      FactoryGirl.create(:earthquake, :lat => -120, :lon => -56)
      search_options = {near: "#{lat},#{lon}"}
      Earthquake.search(search_options).length.should == 1
      search_options = {near: "#{lat},#{lon},5"}
      Earthquake.search(search_options).length.should == 1
      search_options = {near: "#{lat},#{lon},999"}
      Earthquake.search(search_options).length.should == 2
    end

  end

  describe "special cases" do
    it "should retrieve the oldest earthquake from the database" do
      on = 1364582194
      dt = Time.at(on)
      FactoryGirl.create(:earthquake, :datetime => dt)
      FactoryGirl.create(:earthquake, :datetime => dt + 1.day)
      FactoryGirl.create(:earthquake, :datetime => dt - 1.day)
      Earthquake.oldest.datetime.to_s(:db).should == (dt - 1.day).utc.to_s(:db)
    end

    it "should retrieve the newest earthquake from the database" do
      on = 1364582194
      dt = Time.at(on)
      FactoryGirl.create(:earthquake, :datetime => dt)
      FactoryGirl.create(:earthquake, :datetime => dt + 1.day)
      FactoryGirl.create(:earthquake, :datetime => dt - 1.day)
      Earthquake.newest.datetime.to_s(:db).should == (dt + 1.day).utc.to_s(:db)
    end

  end
end
