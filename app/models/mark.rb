# frozen_string_literal: true

class Mark < ApplicationRecord
  belongs_to :map
  has_one_attached :image
  validates :description, length: { maximum: 60 }
end
