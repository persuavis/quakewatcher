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
      FactoryGirl.create(:earthquake, :src => 'test', :datetime => Time.at(datetime_value) - 1.day)
      FactoryGirl.create(:earthquake, :src => 'test', :datetime => Time.at(datetime_value))
      FactoryGirl.create(:earthquake, :src => 'test', :datetime => Time.at(datetime_value) + 1.day)
    end

    it "allows search for records on a particular day" do
      param_str = "on=#{datetime_value}"
      puts "#{url}.json?#{param_str}"
      get "#{url}.json?#{param_str}"
      earthquakes = JSON.parse(response.body)
      earthquakes.length.should == 1
    end

    it "allows search for records since a particular day" do
      param_str = "since=#{datetime_value}"
      puts "#{url}.json?#{param_str}"
      get "#{url}.json?#{param_str}"
      earthquakes = JSON.parse(response.body)
      earthquakes.length.should == 2
    end
  end
end
