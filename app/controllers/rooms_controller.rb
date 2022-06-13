# frozen_string_literal: true

class RoomsController < ApplicationController
  def new
    room = Room.new
    if room.save
      @map = room.build_map
    else
      redirect_to root_path
    end
  end

  def show
    Room.destroy_ten_days_old
    @room = Room.find_by(id: params[:id])
    if @room.nil? || @room.map.nil?
      @room&.destroy
      redirect_to root_path
    else
      cookies.signed[:room_id] = { value: @room.id, expires: 1.month.from_now, httponly: true }
    end
  end

  def destroy
    room = Room.find(params[:id])
    cookies.delete :room_id
    room.destroy
    redirect_to root_path, status: :see_other, notice: 'ルームを削除しました。'
  end
end
