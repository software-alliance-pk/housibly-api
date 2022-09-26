class AddMoreColumnToSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :subscription_histories, :payment_currency, :string
    add_column :subscription_histories, :payment_nature, :string
  end
end
