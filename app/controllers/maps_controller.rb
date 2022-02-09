# frozen_string_literal: true

class MapsController < ApplicationController
  def new
    @map = Map.new
  end

  def create
    @map = Map.new_by(room_id, map_params)

    if @map.save
      redirect_to room_path(room_id), notice: 'マップを登録しました。'
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

  def room_id
    params.permit(:room_id)[:room_id]
  end
end
