class CreateMarks < ActiveRecord::Migration[7.0]
  def change
    create_table :marks do |t|
      t.text :description
      t.string :location, null: false
      t.string :trimming
      t.string :expansion
      t.string :rotation
      t.timestamps
    end
    add_reference :marks, :map, foreign_key: true
  end
end
