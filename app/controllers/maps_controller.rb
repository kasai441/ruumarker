# frozen_string_literal: true

class MapsController < ApplicationController
  def new
    @map = Map.new
  end

  def create
    @room = Room.create!
    @room.map = Map.new(map_params)
    @map = @room.map

    if @map.save
      redirect_to @room, notice: 'マップを登録しました。'
    else
      render :new
    end
  end

  def edit; end

  def show; end

  private

  def map_params
    params.require(:map).permit(:trimming, :expansion, :rotation, :image)
  end
end
