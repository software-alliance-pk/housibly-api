class AddConversationIdToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :conversation_id, :integer, null: true
  end
end
