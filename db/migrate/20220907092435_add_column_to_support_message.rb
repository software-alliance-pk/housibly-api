class AddColumnToSupportMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :support_messages, :type, :string
    add_column :support_messages, :sender_id, :integer
    remove_column :support_messages, :user_id, :integer
  end
end
