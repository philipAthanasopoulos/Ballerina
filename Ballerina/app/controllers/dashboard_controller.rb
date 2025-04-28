class DashboardController < ApplicationController
  def index
    @year = params[:year].present? ? params[:year].to_i : Time.current.year
    @games = Game.where("EXTRACT(YEAR FROM date) = ?", @year)
  end
end
