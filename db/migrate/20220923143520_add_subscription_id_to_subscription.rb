class AddSubscriptionIdToSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :subscriptions, :subscription_id, :string
    add_column :subscriptions, :payment_nature, :string
    add_column :subscriptions, :payment_currency, :string
  end
end
