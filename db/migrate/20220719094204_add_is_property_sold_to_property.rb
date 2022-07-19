class AddIsPropertySoldToProperty < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :is_property_sold, :boolean
  end
end
