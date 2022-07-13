# frozen_string_literal: true

module Api
  class MapsController < ApplicationController
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
      @map = Map.find(params[:id])

      if @map.update(map_params)
        flash[:notice]  = '更新しました！'
        flash[:warning] = '更新しました？'
        flash[:error]   = '更新できず…orz'

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
