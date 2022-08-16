# frozen_string_literal: true

EDIT_SHOW_RATE = 0.8571

module DomHelper
  def pixel(element, *properties)
    values = properties.map do |p|
      element.native.css_value(p).gsub(/px/, '').to_i
    end
    values.size > 1 ? values : values[0]
  end

  def to_show_size(edit_size)
    (edit_size / EDIT_SHOW_RATE).to_i
  end
end
