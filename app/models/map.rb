# frozen_string_literal: true

class Map < ApplicationRecord
  belongs_to :room
  has_many :marks, dependent: :destroy
  has_one_attached :image
  validates :image, presence: true, image: true
end
