require 'spec_helper'

describe "api/earthquakes/list.html.erb" do

  it "renders _earthquake partial for each earthquake" do
    assign(:earthquakes, [stub_model(Earthquake), stub_model(Earthquake)])
    render
    expect(view).to render_template(:partial => "_earthquake", :count => 2)
  end

  it "displays a list of earthquakes" do
    assign(:earthquakes, [stub_model(Earthquake, :src => 'test'), stub_model(Earthquake), stub_model(Earthquake)])
    render
    expect(rendered).to include("test")
  end
end
