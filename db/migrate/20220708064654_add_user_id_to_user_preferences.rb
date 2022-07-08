class AddUserIdToUserPreferences < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_preferences, :user, null: false, foreign_key: true
  end
end
