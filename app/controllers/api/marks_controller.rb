# frozen_string_literal: true

module Api
  class MarksController < ApplicationController
    def update
      @mark = Mark.find(params[:id])
      render json: @mark.errors, status: 422 unless @mark.update(mark_params)
    end

    def destroy
      @mark = Mark.find(params[:id])
      render json: @mark.errors, status: 422 unless @mark.destroy
    end

    private

    def mark_params
      params.require(:mark).permit(:description, :location, :trimming, :expansion, :rotation, :image)
    end
  end
end
