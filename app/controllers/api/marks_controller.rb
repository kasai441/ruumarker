# frozen_string_literal: true

module Api
  class MarksController < ApplicationController
    def update
      @mark = Mark.find(params[:id])
      if @mark.update(mark_params)
        render json: @mark
      else
        render json: @mark.errors, status: 422
      end
    end

    def destroy
      @mark = Mark.find(params[:id])
      if @mark.destroy
        render json: @mark
      else
        render json: @mark.errors, status: 422
      end
    end

    private

    def mark_params
      params.require(:mark).permit(:description, :location, :trimming, :expansion, :rotation, :image)
    end
  end
end
