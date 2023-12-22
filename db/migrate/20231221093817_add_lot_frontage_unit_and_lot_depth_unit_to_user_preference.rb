class AddLotFrontageUnitAndLotDepthUnitToUserPreference < ActiveRecord::Migration[6.1]
  def change
    add_column :user_preferences, :lot_frontage_unit, :string
    add_column :user_preferences, :lot_depth_unit, :string
  end
end
