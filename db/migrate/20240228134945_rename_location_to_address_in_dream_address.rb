class RenameLocationToAddressInDreamAddress < ActiveRecord::Migration[6.1]
  def change
    rename_column :dream_addresses, :location, :address
  end
end
