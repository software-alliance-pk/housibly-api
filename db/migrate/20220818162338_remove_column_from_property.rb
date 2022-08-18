class RemoveColumnFromProperty < ActiveRecord::Migration[6.1]
  def change
    remove_column :properties, :parking_spaces
  end
end
