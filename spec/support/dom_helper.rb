# frozen_string_literal: true

module DomHelper
  def style_value_of(style, property)
    style_hash = css_to_h(style)
    position_to_i(style_hash[property])
  end

  private

  def css_to_h(style)
    style.split(';').map { |e| e.split(':').map(&:strip) }.to_h
  end

  def position_to_i(position)
    position.gsub(/px/, '').to_i
  end
end
