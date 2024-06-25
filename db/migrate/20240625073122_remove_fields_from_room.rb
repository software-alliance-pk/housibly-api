class RemoveFieldsFromRoom < ActiveRecord::Migration[6.1]
  def change
    remove_column :rooms, :width_in_inch, :float
    remove_column :rooms, :length_in_inch, :float
  end  
end
