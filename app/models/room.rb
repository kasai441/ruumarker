# frozen_string_literal: true

class Room < ApplicationRecord
  has_one :map, dependent: :destroy
end
