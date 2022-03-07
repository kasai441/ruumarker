# frozen_string_literal: true

module API
  class MarksController < API::BaseController
    def create
      room = Room.find(params[:room_id])
      mark = room.map.marks.new(mark_params)

      if mark.save
        render json: mark, methods: [:image_url]
      else
        render json: mark.errors, status: 422
      end
    end

    def update
      mark = Mark.find(params[:id])
      if mark.update(mark_params)
        render json: mark, methods: [:image_url]
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
