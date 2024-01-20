class AddHourlyRateToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :hourly_rate, :float
  end
end
