class AddAppleAndGoogleUserIdsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :apple_user_id, :string
    add_column :users, :google_user_id, :string
  end
end
