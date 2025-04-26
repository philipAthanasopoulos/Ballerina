# frozen_string_literal: true

class WinLossTieBarChartComponent < ViewComponent::Base
  def initialize(title:, wins:, losses:, ties:)
    @title = title
    @wins = wins
    @losses = losses
    @ties = ties
    @id_name = title.tr(" ", "-")
  end
end
