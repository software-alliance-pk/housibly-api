class CreateUserSearchAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :user_search_addresses do |t|
      t.references :user, foreign_key: true, index: true
      t.references :user_match_address, foreign_key: true, index:true

      t.timestamps
    end
  end
end
