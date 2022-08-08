# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    room_id = cookies.signed[:room_id]
    room = Room.find_by(id: room_id)
    return unless room

    redirect_to room
  end
end
