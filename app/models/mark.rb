# frozen_string_literal: true

class Mark < ApplicationRecord
  belongs_to :map
  has_one_attached :image
  validates :location, presence: true
  validates :image, presence: true
end
