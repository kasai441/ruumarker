# frozen_string_literal: true

module Api
  class MapsController < ApplicationController
    def show
      @map = Map.find(params[:id])
      render :show
    end

    def create
      room = Room.find(params[:room_id])
      @map = room.build_map(map_params)

      if @map.save
        render :create
      else
        render json: @map.errors, status: 422
      end
    end

    def update
      p params
      p params[:id]
      @map = Map.find(params[:id])
      p @map

      if @map.update(map_params)
        render :update
      else
        render json: @map.errors, status: 422
      end
    end

    private

    def map_params
      params.require(:map).permit(:trimming, :expansion, :rotation, :image)
    end
  end
end
