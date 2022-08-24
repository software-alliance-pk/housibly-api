class ChangeColumTypeToUserPreference < ActiveRecord::Migration[6.1]
  def change
    change_column :user_preferences, :balcony, :string
  end
end
