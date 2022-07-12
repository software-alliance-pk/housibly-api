class AddIsConfirmedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_confirmed, :boolean, default: false
  end
end
