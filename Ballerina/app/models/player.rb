# frozen_string_literal: true

class Player < ActiveRecord::Base
  belongs_to :country
  has_many :goals

  def year_span_of_scoring
    Goal.joins(:game)
        .where(player_id: id)
        .pluck(Arel.sql(
          "CAST(MIN(EXTRACT(YEAR FROM games.date)) AS INT),
                    CAST(MAX(EXTRACT(YEAR FROM games.date)) AS INT)"
        ))
        .first
  end

  def most_goal_in_single_game
    goals.where.not(game_id: nil).group(:game_id).count.values.max
  end

  def goals_to_years_of_activity_ratio
    years = year_span_of_scoring
    goals.count.to_f / (years[1] - years[0] + 1)
  end

  def goals_to_games_per_year_stats
    goals.joins("INNER JOIN games ON games.id = goals.game_id")
         .group("EXTRACT(YEAR FROM games.date)")
         .select("EXTRACT(YEAR FROM games.date) AS year,
                        COUNT(goals.id) * 1.0 / COUNT(DISTINCT games.id) AS ratio")
  end

  def number_of_own_goals
    goals.where(own_goal: true).count
  end
end
