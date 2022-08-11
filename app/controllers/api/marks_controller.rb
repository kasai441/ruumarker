# frozen_string_literal: true

module Api
  class MarksController < ApplicationController
    def create
      room = Room.find(params[:room_id])
      @mark = room.map.marks.new
      render json: @mark.errors, status: :unprocessable_entity unless @mark.save
    end

    def update
      @mark = Mark.find(params[:id])
      render json: @mark.errors, status: :unprocessable_entity unless @mark.update(mark_params)
    end

    def destroy
      @mark = Mark.find(params[:id])
      render json: @mark.errors, status: :unprocessable_entity unless @mark.destroy
    end

    private

    def mark_params
      params.require(:mark).permit(:description, :location, :trimming, :expansion, :rotation, :image)
    end
  end
end
