class ChangeColumnToProperty < ActiveRecord::Migration[6.1]
  def change
    rename_column :properties, :bath_room, :bath_rooms
    rename_column :properties, :bed_room, :bed_rooms
    rename_column :properties, :parking_space, :parking_spaces
    rename_column :properties, :garage_space, :garage_spaces
    rename_column :properties, :other_items, :appliances_and_other_items
  end
end
