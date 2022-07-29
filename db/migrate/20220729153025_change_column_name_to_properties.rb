class ChangeColumnNameToProperties < ActiveRecord::Migration[6.1]
  def change
    rename_column :properties, :lot_size_feet, :lot_size
    rename_column :properties, :lot_size_sq_meter, :lot_size_unit
    rename_column :properties, :lot_depth_feet, :lot_depth
    rename_column :properties, :lot_depth_sq_meter, :lot_depth_unit
    rename_column :properties, :lot_frontage_feet, :lot_frontage
    rename_column :properties, :lot_frontage_sq_meter, :lot_frontage_unit
    add_column :properties, :currency_type, :string
  end
end
