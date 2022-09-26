class AddStatusToMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :read_status, :boolean, default: false
  end
end
