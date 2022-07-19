class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.float :length_in_feet
      t.float :length_in_inch
      t.float :width_in_feet
      t.float :width_in_inch
      t.string :level

      t.timestamps
    end
  end
end
