# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    Room.destroy_ten_days_old
    room_id = cookies.signed[:room_id]
    return unless room_id

    redirect_to Room.find(room_id)
  end
end
