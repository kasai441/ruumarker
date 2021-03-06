# frozen_string_literal: true

class MarksController < ApplicationController
  def new
    room = Room.find(params[:room_id])
    @mark = room.map.marks.create
    redirect_to edit_room_mark_path(room, @mark)
  end

  def edit
    @mark = Mark.find(params[:id])
  end
end
