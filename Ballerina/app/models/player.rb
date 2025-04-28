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
end
