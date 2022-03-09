# frozen_string_literal: true

class Mark < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :map
  has_one_attached :image
  validates :location, presence: true
  validates :image, presence: true, image: true

  def brief_description
    if description.blank?
      '説明なし'
    elsif description.size > 10
      "#{description[0..9]}…"
    else
      description
    end
  end

  def image_url
    image.attached? ? url_for(image) : nil
  end
end
