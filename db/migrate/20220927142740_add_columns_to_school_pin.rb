class AddColumnsToSchoolPin < ActiveRecord::Migration[6.1]
  def change
    add_column :school_pins, :address, :string
  end
end
