# frozen_string_literal: true

class WinLossTieLineChartComponent < ViewComponent::Base
  def initialize(title:, wins:, losses:, ties:, first_year:, last_year:)
    @title = title
    @wins = wins
    @losses = losses
    @ties = ties
    @first_year = first_year
    @last_year = last_year
    @date_range = (first_year..last_year).to_a
    @id_name = title.tr(" ", "-")
  end
end
