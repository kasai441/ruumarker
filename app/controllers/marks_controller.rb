# frozen_string_literal: true

class MarksController < ApplicationController
  def edit
    @mark = Mark.find(params[:id])
  end
end
