class RenameColumnToSubscription < ActiveRecord::Migration[6.1]
  def change
    change_column :subscription_histories, :current_period_start, :string
    change_column :subscription_histories, :current_period_end, :string

  end
end
