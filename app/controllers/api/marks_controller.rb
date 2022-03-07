# frozen_string_literal: true

module Api
  class MarksController < ApplicationController
    def create
      @room = Room.find(params[:room_id])
      @mark = room.map.marks.new(mark_params)

      if mark.save
        redirect_to room_mark_path(@room, @mark), notice: "キズ（#{@mark.brief_description}）を登録しました。"
      else
        render json: mark.errors, status: 422
      end
    end

    def update
      p 'aaaaaaaaaaaaaaaaaaaa'
      p params
      mark = Mark.find(params[:id])
      if mark.update(mark_params)
        render json: mark
      else
        render json: mark.errors, status: 422
      end
    end

    private

    def mark_params
      params.require(:mark).permit(:description, :location, :trimming, :expansion, :rotation, :image)
    end
  end
end
