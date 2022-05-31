# frozen_string_literal: true

module DomHelper
  def pixel(element, property)
    element.native.css_value(property).gsub(/px/, '').to_i
  end
end
