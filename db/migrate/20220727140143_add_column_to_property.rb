class AddColumnToProperty < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :condo_corporation_or_hqa, :text
  end
end
