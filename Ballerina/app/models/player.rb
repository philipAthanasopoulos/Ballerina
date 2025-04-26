# frozen_string_literal: true

class Player < ActiveRecord::Base
  belongs_to :country
  has_many :goals
  def first_year_of_activity

  end
end
