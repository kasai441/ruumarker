# frozen_string_literal: true

class Mark < ApplicationRecord
  belongs_to :map
  has_one_attached :image
  validates :description, length: { maximum: 60 }

  def brief_description
    if description.blank?
      '説明なし'
    elsif description.size > 10
      "#{description[0..9]}…"
    else
      description
    end
  end
end
