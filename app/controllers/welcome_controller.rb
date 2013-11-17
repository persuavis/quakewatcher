class WelcomeController < ApplicationController
  def home
    @earthquake_count = Earthquake.count
    @oldest_earthquake = Earthquake.oldest
    @newest_earthquake = Earthquake.newest
  end
end
