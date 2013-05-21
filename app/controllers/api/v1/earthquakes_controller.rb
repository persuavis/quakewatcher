class Api::V1::EarthquakesController < ApplicationController
  def list
    puts params
    @earthquakes = Earthquake.search(params)
    respond_to do |format|
      format.html
      format.xml { render :xml => @earthquakes.to_xml }
      format.json { render :json => @earthquakes.to_json }
    end
  end
end
