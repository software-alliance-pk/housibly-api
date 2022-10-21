class AddTypeToSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :subscriptions, :sub_type, :string
  end
end
