# frozen_string_literal: true

class CreateMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :maps do |t|
      t.string :trimming
      t.string :expansion
      t.string :rotation
      t.timestamps
    end
    add_reference :maps, :room, foreign_key: true
  end
end
