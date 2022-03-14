# frozen_string_literal: true
include Rails.application.routes.url_helpers

class Map < ApplicationRecord
  belongs_to :room
  has_many :marks, dependent: :destroy
  has_one_attached :image
  validates :image, presence: true, image: true

  def image_url
    image.attached? ? url_for(image) : nil
  end
end
