class ChangeIntToStringToProperties < ActiveRecord::Migration[6.1]
  def change
    change_column :properties, :bath_rooms, :string
    change_column :properties, :bed_rooms, :string
    change_column :properties, :living_space, :string
    change_column :properties, :parking_spaces, :string
    change_column :properties, :garage_spaces, :string

  end
end
