class AddMoreColumnsToproperty < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :total_number_of_rooms, :integer
    add_column :properties, :total_parking_spaces, :integer
  end
end
