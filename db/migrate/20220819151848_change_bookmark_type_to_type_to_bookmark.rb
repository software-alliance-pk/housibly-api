class ChangeBookmarkTypeToTypeToBookmark < ActiveRecord::Migration[6.1]
  def change
    rename_column :bookmarks, :bookmark_type, :type
    change_column :bookmarks, :property_id, :integer, null: true
    change_column :bookmarks, :user_id, :integer, null: true
  end
end
