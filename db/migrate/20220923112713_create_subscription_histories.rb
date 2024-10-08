class CreateSubscriptionHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :subscription_histories do |t|
      t.boolean :cancel_by_user
      t.datetime :current_period_end
      t.datetime :current_period_start
      t.string :plan_title
      t.string :interval_count
      t.string :interval
      t.string :subscription_title
      t.string :status
      t.string :price
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
