# frozen_string_literal: true

class Room < ApplicationRecord
  has_one :map, dependent: :destroy
  before_save :set_id

  private

  def set_id
    while id.blank? || Room.find_by(id: id).present? # rubocop:disable Style/WhileUntilModifier, Style/HashSyntax
      self.id = SecureRandom.alphanumeric(20)
    end
  end
end
