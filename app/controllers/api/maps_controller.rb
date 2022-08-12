# frozen_string_literal: true

module Api
  class MapsController < ApplicationController
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
