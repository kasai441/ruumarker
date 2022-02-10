# frozen_string_literal: true

class MapsController < ApplicationController
  def new
    @map = Map.new
  end

  def create
    @map = Map.new_by(room_id, map_params)

    if @map.save!
      redirect_to @map.room, notice: 'マップを登録しました。'
    else
      render :new
    end
  end

  def edit
    @map = Map.find(map_id)
  end

  def update
    map = Map.find(map_id)
    map.update!(map_params)
    redirect_to map.room, notice: 'マップを変更しました。'
  end

  def show; end

  private

  def map_params
    params.require(:map).permit(:trimming, :expansion, :rotation, :image)
  end

  def room_id
    params.permit(:room_id)[:room_id]
  end

  def map_id
    params.permit(:id)[:id]
  end
end
