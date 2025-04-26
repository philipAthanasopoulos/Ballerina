# frozen_string_literal: true

class Country < ActiveRecord::Base
  has_many :players
  has_many :home_games, class_name: 'Game', foreign_key: :home_team_id
  has_many :away_games, class_name: 'Game', foreign_key: :away_team_id
  has_many :shootouts_as_first_shooter, class_name: 'Shootout', foreign_key: :first_shooter_id
  has_many :shootouts_as_winner, class_name: 'Shootout', foreign_key: :winner_id

  def number_of_games
    number_of_games_as_home + number_of_games_as_away
  end

  def number_of_wins
    number_of_wins_as_home + number_of_wins_as_away
  end

  def number_of_loses
    number_of_loses_as_home + number_of_loses_as_away
  end

  def number_of_ties
    number_of_ties_as_home + number_of_ties_as_away
  end

  def number_of_games_as_home
    home_games.count
  end

  def number_of_wins_as_home
    home_games.where("home_score > away_score").count
  end

  def number_of_wins_shootouts_as_home
    Game.where("home_team_id = ?", id).joins("INNER JOIN shootouts ON games.id = shootouts.game_id")
        .where("? = shootouts.winner_id", id)
        .count
  end

  def number_of_loses_as_home
    home_games.where("home_score < away_score").count
  end

  def number_of_losses_shootouts_as_home
    Game.where("home_team_id = ?", id).joins("INNER JOIN shootouts ON games.id = shootouts.game_id")
        .where("? != shootouts.winner_id", id)
        .count
  end

  def number_of_ties_as_home
    home_games.where(neutral: true).count
  end

  def number_of_games_as_away
    away_games.count
  end

  def number_of_wins_as_away
    away_games.where("home_score < away_score").count
  end

  def number_of_wins_shootouts_as_away
    Game.where("away_team_id = ?", id).joins("INNER JOIN shootouts ON games.id = shootouts.game_id")
        .where("? = shootouts.winner_id", id)
        .count
  end

  def number_of_loses_as_away
    away_games.where("home_score > away_score").count
  end

  def number_of_losses_shootouts_as_away
    away_games.joins("INNER JOIN shootouts ON games.id = shootouts.game_id")
              .count
  end

  def number_of_ties_as_away
    away_games.where(neutral: true).count
  end

  def number_of_players
    players.count
  end

  def first_year_of_activity
    (home_games + away_games).sort_by(&:date).first&.date&.year
  end

  def last_year_of_activity
    (home_games + away_games).sort_by(&:date).last&.date&.year
  end

  def top_scorer
  end

  def wins_per_year_as_home
    home_games.where("home_score > away_score").group("CAST(EXTRACT(year FROM date)AS int)").count
  end

  def losses_per_year_as_home
    home_games.where("home_score < away_score").group("CAST(EXTRACT(year FROM date)AS int)").count
  end

  def ties_per_year_as_home
    home_games.where(neutral: true).group("CAST(EXTRACT(year FROM date)AS int)").count
  end

  def wins_per_year_as_away
    away_games.where("home_score < away_score").group("CAST(EXTRACT(year FROM date)AS int)").count
  end

  def losses_per_year_as_away
    away_games.where("home_score > away_score").group("CAST(EXTRACT(year FROM date)AS int)").count
  end

  def ties_per_year_as_away
    away_games.where(neutral: true).group("CAST(EXTRACT(year FROM date)AS int)").count
  end

  def unique_years_of_activity
    (home_games.pluck(:date) + away_games.pluck(:date)).map(&:year).uniq.sort
  end

  def statistics_per_year_as_home

  end

end
