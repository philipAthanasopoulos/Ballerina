# frozen_string_literal: true

class Shootout < ActiveRecord::Base
  belongs_to :game
  belongs_to :first_shooter, class_name: 'Country', foreign_key: :first_shooter_id
  belongs_to :winner, class_name: 'Country', foreign_key: :winner_id
end
