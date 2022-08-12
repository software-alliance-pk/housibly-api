class AddColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :currency_type, :string
    add_column :users, :currency_amount, :integer
  end
end
