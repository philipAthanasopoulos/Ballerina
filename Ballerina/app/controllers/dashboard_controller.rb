class DashboardController < ApplicationController
  def index
    @year = params[:year].present? ? params[:year].to_i : Time.current.year
    @games = Game.select('games.*, home_countries."Display_Name" AS home_team_name, away_countries."Display_Name" AS away_team_name')
                 .joins('INNER JOIN countries AS home_countries ON games.home_team_id = home_countries.id')
                 .joins('INNER JOIN countries AS away_countries ON games.away_team_id = away_countries.id')
                 .where('EXTRACT(YEAR FROM games.date) = ?', @year)
  end
end
