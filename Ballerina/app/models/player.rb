# frozen_string_literal: true

class Player < ActiveRecord::Base
  belongs_to :country
  has_many :goals

  def year_span_of_scoring
    goals.joins(:game).pluck(:date).minmax
  end

  def most_goal_in_single_game
    goals.group(:game_id).count.values.max
  end

  def goals_to_years_of_activity_ratio
    years = year_span_of_scoring
    goals.count.to_f / (years[1] - years[0] + 1)
  end

  def number_of_own_goals
    goals.where(own_goal: true).count
  end
end
