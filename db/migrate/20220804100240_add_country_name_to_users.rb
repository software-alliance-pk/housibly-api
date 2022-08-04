class AddCountryNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :country_name, :string
  end
end
