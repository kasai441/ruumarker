# frozen_string_literal: true

module Api
  class MapsController < ApplicationController
    def create
      room = Room.find(params[:room_id])
      @map = room.build_map(map_params)
      render json: @map.errors, status: :unprocessable_entity unless @map.save
    end

    def update
      @map = Map.find(params[:id])
      render json: @map.errors, status: :unprocessable_entity unless @map.update(map_params)
    end

    private

    def map_params
      params.require(:map).permit(:trimming, :expansion, :rotation, :image)
    end
  end
end
