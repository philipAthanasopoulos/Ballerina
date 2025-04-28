class LeaderboardController < ApplicationController
  def index
    @countries = Country.all
  end
end
