class AddBlockByToConversation < ActiveRecord::Migration[6.1]
  def change
    add_column :conversations, :block_by, :integer
  end
end
