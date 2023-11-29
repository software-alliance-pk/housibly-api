class ChangeLotUnitDataTypeInProperty < ActiveRecord::Migration[6.1]
  def change
    change_table :properties do |t|
      t.change :lot_frontage_unit, :string
      t.change :lot_depth_unit, :string
      t.change :lot_size_unit, :string
    end
  end
end
