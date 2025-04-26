# frozen_string_literal: true

class Goal < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
end
