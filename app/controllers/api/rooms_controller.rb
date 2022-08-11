# frozen_string_literal: true

module Api
  class RoomsController < ApplicationController
    def create
      @room = Room.new
      render json: @room.errors, status: :unprocessable_entity unless @room.save && @room.create_map(map_params)
    end

    private

    def map_params
      params.require(:map).permit(:trimming, :expansion, :rotation, :image)
    end
  end
end
