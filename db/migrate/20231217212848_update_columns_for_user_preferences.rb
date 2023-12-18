class UpdateColumnsForUserPreferences < ActiveRecord::Migration[6.1]
  def change
    change_table :user_preferences do |t|
      t.remove :min_price, type: :decimal
      t.remove :max_price, type: :decimal
      t.remove :min_bedrooms, type: :string
      t.remove :max_bedrooms, type: :string
      t.remove :min_bathrooms, type: :string
      t.remove :max_bathrooms, type: :string
      t.remove :property_style, type: :string
      t.remove :min_lot_frontage, type: :string
      t.remove :min_lot_size, type: :integer
      t.remove :max_lot_size, type: :integer
      t.remove :min_living_space, type: :integer
      t.remove :max_living_space, type: :integer
      t.remove :max_age, type: :string
      t.remove :parking_spot, type: :string
      t.remove :garbage_spot, type: :string
      t.remove :price_unit, type: :string
      t.remove :living_space_unit, type: :string
      t.remove :property_types, type: :string

      t.column :max_age, :integer
      t.column :is_lot_irregular, :boolean
      t.column :central_vacuum, :boolean
      t.column :currency_type, :string
      t.column :driveway, :string
      t.column :water, :string
      t.column :sewer, :string
      t.column :pool, :string
      t.column :exposure, :string
      t.column :pets_allowed, :string
      t.column :house_style, :string, array: true, default: []
      t.column :house_type, :string, array: true, default: []
      t.column :condo_style, :string, array: true, default: []
      t.column :condo_type, :string, array: true, default: []
      t.column :exterior, :string, array: true, default: []
      t.column :included_utilities, :string, array: true, default: []
      t.column :basement, :string, array: true, default: []
      t.column :heat_source, :string, array: true, default: []
      t.column :heat_type, :string, array: true, default: []
      t.column :air_conditioner, :string, array: true, default: []
      t.column :fireplace, :string, array: true, default: []
      t.column :price, :json
      t.column :lot_size, :json
      t.column :lot_depth, :json
      t.column :lot_frontage, :json
      t.column :bed_rooms, :json
      t.column :bath_rooms, :json
      t.column :garage_spaces, :json
      t.column :total_number_of_rooms, :json
      t.column :total_parking_spaces, :json
    end
  end
end
