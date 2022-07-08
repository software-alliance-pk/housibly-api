class CreateUserPreferences < ActiveRecord::Migration[6.1]
  def change
    create_table :user_preferences do |t|
      t.integer :property_type
      t.decimal :min_price
      t.decimal :max_price
      t.integer :min_bedrooms
      t.integer :max_bedrooms
      t.integer :min_bathrooms
      t.integer :max_bathrooms
      t.string :property_style
      t.integer :min_lot_frontage
      t.integer :min_lot_size
      t.integer :max_lot_size
      t.integer :min_living_space
      t.integer :max_living_space
      t.integer :parking_spot
      t.integer :garbage_spot
      t.integer :max_age
      t.boolean :balcony
      t.string :security
      t.string :laundry

      t.timestamps
    end
  end
end
