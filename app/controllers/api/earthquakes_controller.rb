class Api::EarthquakesController < ApplicationController
  def list
    puts params
    @earthquakes = Earthquake.all
    respond_to do |format|
      format.html
      format.xml { render :xml => @earthquakes.to_xml }
      format.json { render :json => @earthquakes.to_json }
    end
  end
end
