class AddColumnDreamAddress < ActiveRecord::Migration[6.1]
  def change
    add_column  :dream_addresses, :longitude, :float
    add_column  :dream_addresses,  :latitude, :float
  end
end
