# frozen_string_literal: true

module Api
  class MapsController < ApplicationController
    def create
      room = Room.find(params[:room_id])
      map = room.build_map(map_params)

      if map.save
        render json: map, methods: [:image_url]
      else
        render json: map.errors, status: 422
      end
    end

    private

    def map_params
      params.require(:map).permit(:trimming, :expansion, :rotation, :image)
    end
  end
end
