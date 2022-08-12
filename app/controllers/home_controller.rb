# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    room_id = cookies.signed[:room_id]
    return unless room_id

    room = Room.find(room_id)
    redirect_to room
  end
end
