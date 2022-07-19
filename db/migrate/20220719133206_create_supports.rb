class CreateSupports < ActiveRecord::Migration[6.1]
  def change
    create_table :supports do |t|
      t.string :ticket_number
      t.integer :status, default: 0
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
