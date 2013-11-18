require 'spec_helper'

describe "welcome/search.html.erb" do

  it "renders the search page" do
    render
    expect(view).to render_template('search')
    rendered.should =~ /QuakeWatcher - Search the Earthquakes Database/
  end

  it "renders a search form" do
    render
    rendered.should have_selector("form", :method => 'get', :action => '/welcome/search') do |form|
      form.should have_selector("input", :type => 'submit')
    end
  end

  it "renders a search form with a input field for on" do
    # on, since, over, near
    render
    rendered.should have_selector("form", :method => 'get', :action => '/welcome/search') do |form|
      form.should have_selector("input", :type => 'text', :name => 'on')
    end
  end

  it "renders a search form with an input field for since" do
    render
    rendered.should have_selector("form", :method => 'get', :action => '/welcome/search') do |form|
      form.should have_selector("input", :type => 'text', :name => 'since')
    end
  end

  it "renders a search form with an input field for over" do
    render
    rendered.should have_selector("form", :method => 'get', :action => '/welcome/search') do |form|
      form.should have_selector("input", :type => 'text', :name => 'over')
    end
  end

  it "renders a search form with an input field for near" do
    render
    rendered.should have_selector("form", :method => 'get', :action => '/welcome/search') do |form|
      form.should have_selector("input", :type => 'text', :name => 'near')
    end
  end

  it "renders a search form with an input field for limit" do
    render
    rendered.should have_selector("form", :method => 'get', :action => '/welcome/search') do |form|
      form.should have_selector("input", :type => 'text', :name => 'limit')
    end
  end

  it "renders a list of earthquakes returned from a search" do
    earthquake = mock_model(Earthquake, :attributes => [:magnitude => 6.123])
    assign(:earthquakes, [earthquake])
    render
    rendered.should contain("6.123")
  end

end
