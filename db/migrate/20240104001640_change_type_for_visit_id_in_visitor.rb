class ChangeTypeForVisitIdInVisitor < ActiveRecord::Migration[6.1]
  def change
    change_table :visitors do |t|
      reversible do |direction|
        direction.up { t.change :visit_id, :bigint }
        direction.down { t.change :visit_id, :int }
      end
      t.index :visit_id
    end
  end
end
