class RemoveColumnToSupportConversation < ActiveRecord::Migration[6.1]
  def change
    remove_column :support_conversations, :deleted_at, :datetime
  end
end
