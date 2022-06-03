# frozen_string_literal: true

class ReportsController < ApplicationController
  def index
    @room = Room.find(params[:room_id])
  end
end
