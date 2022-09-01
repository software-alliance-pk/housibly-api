class CreateVisitors < ActiveRecord::Migration[6.1]
  def change
    create_table :visitors do |t|
      t.references :user, foreign_key: true, index: true
      t.integer :visit_id

      t.timestamps
    end
  end
end
