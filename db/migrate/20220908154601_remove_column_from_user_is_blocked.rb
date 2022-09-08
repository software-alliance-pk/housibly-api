class RemoveColumnFromUserIsBlocked < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :is_blocked, :boolean
  end
end
