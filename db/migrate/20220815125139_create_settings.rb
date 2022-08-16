class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.integer :csv_count

      t.timestamps
    end
  end
end
