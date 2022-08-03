# frozen_string_literal: true

class MapsController < ApplicationController
  def new
    room = Room.new
    if room.save
      @map = room.build_map
    else
      redirect_to root_path
    end
  end

  def edit
    @map = Map.find(params[:id])
  end
end
