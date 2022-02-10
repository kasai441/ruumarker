# frozen_string_literal: true

class MapsController < ApplicationController
  def new
    @map = Map.new
  end

  def create
    @map = Map.new_by(params[:room_id], map_params)

    if @map.save!
      redirect_to @map.room, notice: 'マップを登録しました。'
    else
      render :new
    end
  end

  def edit
    @map = Map.find(params[:id])
  end

  def update
    map = Map.find(params[:id])
    map.update!(map_params)
    redirect_to map.room, notice: 'マップを変更しました。'
  end

  private

  def map_params
    params.require(:map).permit(:trimming, :expansion, :rotation, :image)
  end
end
