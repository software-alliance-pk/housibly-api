class CreateUserMatchAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :user_match_addresses do |t|
      t.string :address

      t.timestamps
    end
  end
end
