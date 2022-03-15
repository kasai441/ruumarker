# frozen_string_literal: true

class RoomsController < ApplicationController
  def new
    @room = Room.new

    if @room.save
      redirect_to new_room_map_path(@room)
    else
      redirect_to root_path
    end
  end

  def show
    @room = Room.find(params[:id])
    redirect_to root_path unless @room.map.present?
    cookies.signed[:room_id] = { value: @room.id, expires: 1.month.from_now }
  end

  def destroy
    room = Room.find(params[:id])
    cookies.delete :room_id
    room.destroy
    redirect_to root_path, status: :see_other, notice: 'ルームを削除しました。'
  end
end
