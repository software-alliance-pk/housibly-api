class MakeUserIdRequiredForBookmark < ActiveRecord::Migration[6.1]
  def change
    reversible do |direction|
      direction.up { change_column :bookmarks, :user_id, :bigint, null: false }
      direction.down { change_column :bookmarks, :user_id, :bigint, null: true }
    end
  end
end
