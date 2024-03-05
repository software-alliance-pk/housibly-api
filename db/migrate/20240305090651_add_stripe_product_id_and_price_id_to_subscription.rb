class AddStripeProductIdAndPriceIdToSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :subscriptions, :stripe_product_id, :string
    add_column :subscriptions, :stripe_price_id, :string
  end
end
