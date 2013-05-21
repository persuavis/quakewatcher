require 'spec_helper'

describe "routing to earthquakes" do
  it "routes /earthquakes to api/v1/earthquakes/list" do
    expect(:get => "/earthquakes").to route_to(:controller => "api/v1/earthquakes", :action => "list")
  end

  it "does not expose an individual earthquake" do
    expect(:get => "/earthquakes/show").not_to be_routable
  end
end