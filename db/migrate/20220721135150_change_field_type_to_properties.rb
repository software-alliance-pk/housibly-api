class ChangeFieldTypeToProperties < ActiveRecord::Migration[6.1]
  def change
    change_column :properties, :locker, :string
  end
end
