# frozen_string_literal: true

class MapComponent < ViewComponent::Base
  def initialize(country:)
    @country = country
  end
end
