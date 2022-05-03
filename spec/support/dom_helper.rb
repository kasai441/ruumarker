# frozen_string_literal: true

module DomHelper
  def style_value_of(style, property)
    style_hash = css_to_h(style)
    position_to_i(style_hash[property])
  end

  private

  def css_to_h(style)
    if style
      style.split(';').map { |e| e.split(':').map(&:strip) }.to_h
    else
      {}
    end
  end

  def position_to_i(position)
    position ? position.gsub(/px/, '').to_i : 0
  end
end
