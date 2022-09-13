class AddDeletedAtToConversation < ActiveRecord::Migration[6.1]
  def change
    add_column :conversations, :deleted_at, :datetime
    add_index :conversations, :deleted_at
    add_column :support_conversations, :deleted_at, :datetime
    add_index :support_conversations, :deleted_at
  end
end
