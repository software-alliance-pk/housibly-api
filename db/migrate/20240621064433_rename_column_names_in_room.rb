class RenameColumnNamesInRoom < ActiveRecord::Migration[6.1]
  def change
    rename_column :rooms, :length_in_feet, :room_length
    rename_column :rooms, :width_in_feet, :room_width
  end
end
