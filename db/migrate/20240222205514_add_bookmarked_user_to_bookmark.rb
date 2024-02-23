class AddBookmarkedUserToBookmark < ActiveRecord::Migration[6.1]
  def change
    add_reference :bookmarks, :bookmarked_user, foreign_key: { to_table: :users }
  end
end
