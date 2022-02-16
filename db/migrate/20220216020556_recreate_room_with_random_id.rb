class RecreateRoomWithRandomId < ActiveRecord::Migration[7.0]
  def up
    remove_reference :maps, :room, foreign_key: true
    drop_table :rooms, &:timestamps
    create_table :rooms, id: :string, :limit=>20, &:timestamps
    add_reference :maps, :room, foreign_key: true, type: :string
  end

  def down
    remove_reference :maps, :room, foreign_key: true, type: :string
    drop_table :rooms, id: :string, :limit=>20, &:timestamps
    create_table :rooms, &:timestamps
    add_reference :maps, :room, foreign_key: true
  end
end
