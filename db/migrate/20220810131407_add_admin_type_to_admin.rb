class AddAdminTypeToAdmin < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :admin_type, :integer, default: 1
    add_column :admins, :full_name, :string
    add_column :admins, :user_name, :string
    add_column :admins, :status, :integer
    add_column :admins, :location, :boolean
    add_column :admins, :phone_number, :integer
  end
end
