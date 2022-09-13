class RenameColumnToConversationIsBlocked < ActiveRecord::Migration[6.1]
  def change
    change_column :conversations, :is_blocked, :boolean, default: false
  end
end
