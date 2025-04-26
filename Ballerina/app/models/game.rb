# frozen_string_literal: true

class Game < ActiveRecord::Base
  belongs_to :home_team, class_name: 'Country', foreign_key: :home_team_id
  belongs_to :away_team, class_name: 'Country', foreign_key: :away_team_id
  belongs_to :country
  has_many :goals
  has_one :shootout
end
