class CreateSearchedAddress < ActiveRecord::Migration[6.1]
  def change
    create_table :searched_addresses do |t|
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
