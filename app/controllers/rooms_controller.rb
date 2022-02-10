# frozen_string_literal: true

class RoomsController < ApplicationController
  def new
    create
  end

  def create
    @room = Room.new

    if @room.save!
      redirect_to new_room_map_path(@room)
    else
      redirect_to new_room_path
    end
  end

  def show
    @room = Room.find(params[:id])
  end

  def destroy
    room = Room.find(params[:id])
    room.destroy
    redirect_to root_path, status: :see_other, notice: 'ルームを削除しました。'
  end
end
