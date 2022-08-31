class AddMoreColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_reported, :boolean, default: false
    add_column :users, :is_blocked, :boolean, default:false
  end
end
