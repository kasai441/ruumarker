# frozen_string_literal: true

class MarksController < ApplicationController
  def new
    room = Room.find(params[:room_id])
    @mark = room.map.marks.new
  end

  def create
    @room = Room.find(params[:room_id])
    @mark = @room.map.marks.new(mark_params)

    if @mark.save
      redirect_to @room, notice: 'マークを登録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @mark = Mark.find(params[:id])
  end

  def edit
    @mark = Mark.find(params[:id])
  end

  def update
    @mark = Mark.find(params[:id])
    if @mark.update(mark_params)
      redirect_to @mark.map.room, notice: "キズ（#{@mark.id}）を変更しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    mark = Mark.find(params[:id])
    mark.destroy
    redirect_to mark.map.room, status: :see_other, notice: "キズ（#{mark.id}）を削除しました。"
  end

  private

  def mark_params
    params.require(:mark).permit(:description, :location, :trimming, :expansion, :rotation, :image)
  end
end
