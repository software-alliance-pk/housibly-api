class AddReadStatusToSupportMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :support_messages, :read_status, :boolean, default: false
  end
end
