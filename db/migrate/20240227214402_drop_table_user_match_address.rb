class DropTableUserMatchAddress < ActiveRecord::Migration[6.1]
  def change
    remove_reference(:user_search_addresses, :user_match_address, foreign_key: true)

    drop_table :user_match_addresses do |t|
      t.string :address
      t.timestamps
    end
  end
end
