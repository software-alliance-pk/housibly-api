class CreateProperty < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.string :type
      t.string :title
      t.float :price
      t.integer :year_built
      t.string :address
      t.integer :unit
      t.float :lot_frontage
      t.float :lot_depth
      t.float :lot_size
      t.boolean :is_lot_irregular
      t.text :lot_description
      t.integer :bath_room
      t.integer :bed_room
      t.integer :living_space
      t.integer :parking_space
      t.integer :garage_space
      t.boolean :garage
      t.boolean :parking_type
      t.boolean :parking_ownership
      t.string :condo_type
      t.string :condo_style
      t.boolean :driveway
      t.string :house_type
      t.string :house_style
      t.boolean :exterior
      t.boolean :water
      t.boolean :sewer
      t.boolean :heat_source
      t.boolean :air_conditioner
      t.boolean :laundry
      t.boolean :fire_place
      t.boolean :central_vacuum
      t.boolean :basement
      t.boolean :pool
      t.integer :property_tax
      t.integer :tax_year
      t.string :other_items
      t.boolean :locker
      t.float :condo_fees
      t.boolean :balcony
      t.boolean :exposure
      t.boolean :security
      t.boolean :pets_allowed
      t.boolean :included_utilities
      t.text :property_description

      t.timestamps
    end
  end
end
