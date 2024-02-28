class AddSearchedAddressReferenceToUserSearchAddress < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_search_addresses, :searched_address, null: false, foreign_key: true
  end
end
