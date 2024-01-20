class ChangeTypeForSupportCloserIdInReview < ActiveRecord::Migration[6.1]
  def change
    change_table :reviews do |t|
      reversible do |direction|
        direction.up { t.change :support_closer_id, :bigint }
        direction.down { t.change :support_closer_id, :int }
      end
      t.index :support_closer_id
    end
  end
end
