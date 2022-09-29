class AddCityCountryToProperty < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :city, :string
    add_column :properties, :country, :string
  end
end
