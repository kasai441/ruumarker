# frozen_string_literal: true

module DomHelper
  def style_px_to_i(element, property)
    element.native.css_value(property).gsub(/px/, '').to_i
  end
end
