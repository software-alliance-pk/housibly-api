class ChangeColumnToNotification < ActiveRecord::Migration[6.1]
  def change
    change_column :notifications, :conversation_id, :integer, null:true
  end
end
