class RemoveNotNullConstraintFromMarks < ActiveRecord::Migration[7.0]
  def up
    change_column :marks, :location, :string, :null => true
  end

  def down
    change_column :marks, :location, :string, :null => false
  end
end
