require 'spec_helper'

describe "welcome/home.html.erb" do

  it "renders the home page" do
    render
    expect(view).to render_template('home')
    rendered.should contain("QuakeWatcher - Keep Track of Recent Earthquakes")
  end

  it "displays a count of earthquakes" do
    assign(:earthquake_count, 555)
    render
    rendered.should contain("555")
  end

  it "displays the newest earthquake" do
    assign(:oldest_earthquake, mock_model(Earthquake, :attributes => [:magnitude => 6.1]))
    render
    rendered.should contain("newest earthquake")
    rendered.should contain("6.1")
  end

  it "displays the oldest earthquake" do
    assign(:oldest_earthquake, mock_model(Earthquake, :attributes => [:depth => 3.123]))
    render
    rendered.should contain("oldest earthquake")
    rendered.should contain("3.123")
  end
end
