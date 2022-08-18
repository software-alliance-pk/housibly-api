class AddIsBookmarkToProperty < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :is_bookmark, :boolean, default: false
  end
end
