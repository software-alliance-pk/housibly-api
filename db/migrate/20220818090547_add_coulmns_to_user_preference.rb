class AddCoulmnsToUserPreference < ActiveRecord::Migration[6.1]
  def change
    add_column :user_preferences, :price_unit, :string
    add_column :user_preferences, :living_space_unit, :string
    add_column :user_preferences, :lot_size_unit, :string
  end
end
