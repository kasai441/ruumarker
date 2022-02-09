# frozen_string_literal: true

class Map < ApplicationRecord
  belongs_to :room

  def self.new_by(room_id, map_params)
    room = Room.find(room_id)
    room.map = Map.new(map_params)
  end
end
