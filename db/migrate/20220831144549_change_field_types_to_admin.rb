class ChangeFieldTypesToAdmin < ActiveRecord::Migration[6.1]
  def down
    change_column :admins, :phone_number, :string
    remove_column :admins, :status
    remove_column :admins, :location
    add_column :admins, :status, :boolean, default: :true
    add_column :admins, :location, :string
  end
  def up
    change_column :admins, :phone_number, :string
    remove_column :admins, :status
    remove_column :admins, :location
    add_column :admins, :status, :boolean, default: :true
    add_column :admins, :location, :string
  end
end
