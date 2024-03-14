class CreateCurrencyConversions < ActiveRecord::Migration[6.1]
  def change
    create_table :currency_conversions do |t|
      t.json :rates

      t.timestamps
    end
  end
end
