# frozen_string_literal: true

module DomHelper
  def pixel(element, *properties)
    values = properties.map do
      |p| element.native.css_value(p).gsub(/px/, '').to_i
    end
    values.size > 1 ? values : values[0]
  end
end
