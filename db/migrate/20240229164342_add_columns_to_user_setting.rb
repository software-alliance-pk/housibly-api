class AddColumnsToUserSetting < ActiveRecord::Migration[6.1]
  def change
    add_column :user_settings, :vibration, :boolean, default: true
    add_column :user_settings, :payment_method, :string, default: 'credit_card'
  end
end
