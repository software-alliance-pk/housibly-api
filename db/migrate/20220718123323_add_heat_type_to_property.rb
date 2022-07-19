class AddHeatTypeToProperty < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :heat_type, :string
  end
end
