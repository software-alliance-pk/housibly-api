class AddZipCodeToProperty < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :zip_code, :string
  end
end
