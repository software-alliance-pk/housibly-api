class ChangeColumnTypeToProperty < ActiveRecord::Migration[6.1]
  def change
    change_column :properties, :garage, :string
    change_column :properties, :driveway, :string
    change_column :properties, :exterior, :string
    change_column :properties, :water, :string
    change_column :properties, :sewer, :string
    change_column :properties, :heat_source, :string
    change_column :properties, :air_conditioner, :string
    change_column :properties, :laundry, :string
    change_column :properties, :fire_place, :string
    change_column :properties, :central_vacuum, :string
    change_column :properties, :basement, :string
    change_column :properties, :pool, :string
    change_column :properties, :parking_type, :string
    change_column :properties, :parking_ownership, :string
    change_column :properties, :balcony, :string
    change_column :properties, :exposure, :string
    change_column :properties, :security, :string
    change_column :properties, :pets_allowed, :string
    change_column :properties, :included_utilities, :string
  end
end
