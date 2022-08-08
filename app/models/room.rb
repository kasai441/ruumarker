# frozen_string_literal: true

class Room < ApplicationRecord
  has_one :map, dependent: :destroy
  before_save :set_id

  def self.destroy_ten_days_old
    Room.where.not(created_at: 10.days.ago.beginning_of_day..).destroy_all
  end

  private

  def set_id
    while id.blank? || Room.find_by(id: id).present? # rubocop:disable Style/WhileUntilModifier, Style/HashSyntax
      self.id = SecureRandom.alphanumeric(20)
    end
  end
end
