class CreateCardInfo < ActiveRecord::Migration[6.1]
  def change
    create_table :card_infos do |t|
      t.string :card_id
      t.string :number
      t.integer :exp_month
      t.integer :exp_year
      t.string :cvc
      t.string :brand
      t.string :country
      t.string :fingerprint
      t.string :last4

      t.timestamps
    end
  end
end
