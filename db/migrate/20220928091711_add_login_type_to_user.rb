class AddLoginTypeToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :login_type, :string
    add_column :users, :profile_complete, :boolean
  end
end
