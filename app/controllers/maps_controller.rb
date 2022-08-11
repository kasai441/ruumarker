# frozen_string_literal: true

class MapsController < ApplicationController
  def edit
    @map = Map.find(params[:id])
  end
end
