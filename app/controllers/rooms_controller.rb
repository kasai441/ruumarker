# frozen_string_literal: true

class RoomsController < ApplicationController
  def new; end

  def show
    @room = Room.find(params[:id])
    cookies.signed[:room_id] = { value: @room.id, expires: 1.month.from_now, httponly: true }
  end
end
