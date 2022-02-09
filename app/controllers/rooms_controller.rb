# frozen_string_literal: true

class RoomsController < ApplicationController
  def show
    @room = Room.find(params[:id])
  end

  def new; end

  def edit; end

  def destroy; end
end
