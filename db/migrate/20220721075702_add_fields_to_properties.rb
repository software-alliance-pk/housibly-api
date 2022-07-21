class AddFieldsToProperties < ActiveRecord::Migration[6.1]
  def change
    rename_column :properties, :lot_frontage, :lot_frontage_feet
    rename_column :properties, :lot_depth, :lot_depth_feet
    rename_column :properties, :lot_size, :lot_size_feet
    add_column :properties, :lot_frontage_sq_meter, :float
    add_column :properties, :lot_depth_sq_meter, :float
    add_column :properties, :lot_size_sq_meter, :float
  end
end
