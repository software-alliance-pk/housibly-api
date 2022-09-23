class RenameColumnToSubscription < ActiveRecord::Migration[6.1]
  def change
    change_column :subscriptions, :current_period_end, :string
    change_column :subscriptions, :current_period_start, :string
  end
end
