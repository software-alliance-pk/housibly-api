class AddReadStatusToSupportConversation < ActiveRecord::Migration[6.1]
  def change
    add_column :support_conversations, :read_status, :boolean, default: false
    add_column :support_conversations, :online, :boolean, default: false
  end
end
