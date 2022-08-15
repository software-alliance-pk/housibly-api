class CreateSchoolPins < ActiveRecord::Migration[6.1]
  def change
    create_table :school_pins do |t|
      t.string :pin_name
      t.float :longtitude
      t.float :latitude

      t.timestamps
    end
  end
end
