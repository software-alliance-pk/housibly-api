class AddColumnToSupportConversation < ActiveRecord::Migration[6.1]
  def change
    add_column :support_conversations, :available, :boolean
    add_column :support_conversations, :un_read, :integer
  end
end
