class ChangeFieldTypesToUserPreferences < ActiveRecord::Migration[6.1]
  def change
    change_column :user_preferences, :property_type, :string
    change_column :user_preferences, :min_bedrooms, :string
    change_column :user_preferences, :max_bedrooms, :string
    change_column :user_preferences, :min_bathrooms, :string
    change_column :user_preferences, :max_bathrooms, :string
    change_column :user_preferences, :min_lot_frontage, :string
    change_column :user_preferences, :parking_spot, :string
    change_column :user_preferences, :garbage_spot, :string
    change_column :user_preferences, :max_age, :string
    add_column :user_preferences, :property_types, :string
  end
end
