class ChangeColumnTypesForBookmark < ActiveRecord::Migration[6.1]
  def change
    reversible do |direction|
      change_table :bookmarks do |t|
        direction.up { t.change :user_id, :bigint }
        direction.down { t.change :user_id, :int }

        direction.up { t.change :property_id, :bigint }
        direction.down { t.change :property_id, :int }
      end
    end
  end
end
