class CreateDreamAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :dream_addresses do |t|
      t.string :location
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
