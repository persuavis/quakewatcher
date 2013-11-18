class WelcomeController < ApplicationController
  def home
    @earthquake_count = Earthquake.count
    @oldest_earthquake = Earthquake.oldest
    @newest_earthquake = Earthquake.newest
  end

  def search
    @earthquakes = Earthquake.search(params).limit(record_limit)
  end

  private
  def record_limit
    @limit = params[:limit].to_i
    @limit = 20 if @limit <= 0
    params[:limit] = "#{@limit}"
  end
end
