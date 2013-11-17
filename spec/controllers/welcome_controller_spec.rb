require "spec_helper"

describe WelcomeController do

  describe "GET home" do
    it "gets the count of earthquakes" do
      Earthquake.should_receive(:count).and_return(444)
      get :home
      assigns[:earthquake_count].should == 444
    end

    it "gets the oldest earthquake" do
      oldest_earthquake = Earthquake.new(:datetime => DateTime.now)
      Earthquake.should_receive(:oldest).and_return(oldest_earthquake)
      get :home
      assigns[:oldest_earthquake].should == oldest_earthquake
    end

    it "gets the newest earthquake" do
      newest_earthquake = Earthquake.new(:datetime => DateTime.now)
      Earthquake.should_receive(:newest).and_return(newest_earthquake)
      get :home
      assigns[:newest_earthquake].should == newest_earthquake
    end

  end
end