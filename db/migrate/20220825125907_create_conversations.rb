class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.integer :recipient_id, index: true
      t.integer :sender_id, index: true
      t.integer :unread_message

      t.timestamps
    end
  end
end
