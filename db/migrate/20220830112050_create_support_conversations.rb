class CreateSupportConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :support_conversations do |t|
      t.references :support, foreign_key: true, index: true
      t.integer :recipient_id
      t.integer :sender_id
      t.integer :conv_type

      t.timestamps
    end
  end
end
