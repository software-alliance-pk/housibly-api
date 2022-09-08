class RenameColumnToConversation < ActiveRecord::Migration[6.1]
  def change
    change_column :conversations, :unread_message, :integer, default: 0
  end
end
