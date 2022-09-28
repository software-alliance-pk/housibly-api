class AddCityCountryToSchoolPin < ActiveRecord::Migration[6.1]
  def change
    add_column :school_pins, :city, :string
    add_column :school_pins, :country, :string
  end
end
