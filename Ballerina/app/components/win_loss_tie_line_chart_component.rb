# frozen_string_literal: true

class WinLossTieLineChartComponent < ViewComponent::Base
  def initialize(title:, wins:, losses:, ties:, date_range:)
    @title = title
    @wins = wins
    @losses = losses
    @ties = ties
    @date_range = date_range
    @id_name = title.tr(" ", "-")
  end
end
