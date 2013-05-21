require "spec_helper"

describe "/api/v1/earthquakes", :type => :api do

  let(:url) { "/api/v1/earthquakes/list" }
  let(:datetime_value) { 1364582194 }

  context "viewable earthquakes" do

    it "supports HTML format" do
      FactoryGirl.create(:earthquake, :src => 'test', :datetime => Time.at(datetime_value))
      get "#{url}"
      response.status.should eql(200)
      earthquakes = Nokogiri::HTML(response.body)
      earthquakes.css("ul li div ul li").first.text.should eql("test")
    end

    it "supports JSON format" do
      FactoryGirl.create(:earthquake, :src => 'test', :datetime => Time.at(datetime_value))
      earthquakes_json = Earthquake.all.to_json
      get "#{url}.json"
      response.body.should eql(earthquakes_json)
      response.status.should eql(200)
      earthquakes = JSON.parse(response.body)
      earthquakes.any? do |p|
        p["src"] == 'test'
      end.should be_true
    end

    it "supports XML format" do
      FactoryGirl.create(:earthquake, :src => 'test', :datetime => Time.at(datetime_value))
      get "#{url}.xml"
      response.body.should eql(Earthquake.all.to_xml)
      earthquakes = Nokogiri::XML(response.body)
      earthquakes.css("earthquake src").text.should eql("test")
    end
  end

  context "search parameters" do
    before(:each) do
      FactoryGirl.create(:earthquake, :src => 'test', :datetime => Time.at(datetime_value) - 2.days, :magnitude => 4.6, :lat => 36.67,  :lon => -114.89)
      FactoryGirl.create(:earthquake, :src => 'test', :datetime => Time.at(datetime_value) - 1.day,  :magnitude => 1.0, :lat => 97,     :lon => 67)
      FactoryGirl.create(:earthquake, :src => 'test', :datetime => Time.at(datetime_value),          :magnitude => 2.0, :lat => -97,    :lon => 67)
      FactoryGirl.create(:earthquake, :src => 'test', :datetime => Time.at(datetime_value) + 1.day,  :magnitude => 3,   :lat => 97,     :lon => -67)
    end

    it "returns all records if no parameters specified" do
      get "#{url}.json"
      earthquakes = JSON.parse(response.body)
      earthquakes.length.should == 4
    end

    it "allows search for records on a particular day" do
      param_str = "on=#{datetime_value}"
      get "#{url}.json?#{param_str}"
      earthquakes = JSON.parse(response.body)
      earthquakes.length.should == 1
    end

    it "allows search for records since a particular day" do
      param_str = "since=#{datetime_value}"
      get "#{url}.json?#{param_str}"
      earthquakes = JSON.parse(response.body)
      earthquakes.length.should == 2
    end

    it "allows search for records over a particular magnitude" do
      param_str = "over=2"
      get "#{url}.json?#{param_str}"
      earthquakes = JSON.parse(response.body)
      earthquakes.length.should == 2
    end

    it "allows search for records near a particular location" do
      param_str = "near=-97,67"
      get "#{url}.json?#{param_str}"
      earthquakes = JSON.parse(response.body)
      earthquakes.length.should == 1
    end

    it "allows search with various parameter combinations" do
      param_str = "over=2.2&near=36.6702,-114.8870&since=#{datetime_value-3*86400}"
      get "#{url}.json?#{param_str}"
      earthquakes = JSON.parse(response.body)
      earthquakes.length.should == 1
    end

  end
end
