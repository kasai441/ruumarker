# frozen_string_literal: true

class RoomsController < ApplicationController
  def show
    @room = Room.find_by(id: params[:id])
    if @room.nil? || @room.map.nil?
      @room&.destroy
      redirect_to root_path
    else
      cookies.signed[:room_id] = { value: @room.id, expires: 1.month.from_now, httponly: true }
    end
  end
end
