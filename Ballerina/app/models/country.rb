# frozen_string_literal: true

class Country < ActiveRecord::Base
  has_many :players
  has_many :home_games, class_name: 'Game', foreign_key: :home_team_id
  has_many :away_games, class_name: 'Game', foreign_key: :away_team_id
  has_many :shootouts_as_first_shooter, class_name: 'Shootout', foreign_key: :first_shooter_id
  has_many :shootouts_as_winner, class_name: 'Shootout', foreign_key: :winner_id

  def global_score
    number_of_wins*3 + number_of_ties
  end

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

  def yearly_statistics
    games = (home_games + away_games).sort_by(&:date)
    years = (games.map { |game| game.date.year }.uniq.min..games.map { |game| game.date.year }.uniq.max).to_a

    wins = years.map do |year|
      games.select { |game| game.date.year == year && ((game.home_team_id == id && game.home_score > game.away_score) || (game.away_team_id == id && game.away_score > game.home_score)) }.count
    end

    losses = years.map do |year|
      games.select { |game| game.date.year == year && ((game.home_team_id == id && game.home_score < game.away_score) || (game.away_team_id == id && game.away_score < game.home_score)) }.count
    end

    ties = years.map do |year|
      games.select { |game| game.date.year == year && game.home_score == game.away_score }.count
    end

    first_year = years.first
    last_year = years.last

    {
      wins: wins,
      losses: losses,
      ties: ties,
      first_year: first_year,
      last_year: last_year
    }
  end

end
