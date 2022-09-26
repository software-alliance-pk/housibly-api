class AddMoreColumnsToSubscription < ActiveRecord::Migration[6.1]
  def change
    change_column :subscriptions, :current_period_start, :string
    change_column :subscriptions, :current_period_end, :string
    add_column :subscriptions, :payment_currency, :string
    add_column :subscriptions, :payment_nature, :string
  end
end
