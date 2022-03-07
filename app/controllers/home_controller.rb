# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    room_id = cookies.signed[:room_id]
    return unless (room = Room.find_by(id: room_id))

    redirect_to room
  end
end