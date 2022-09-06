class CreateReportings < ActiveRecord::Migration[6.1]
  def change
    create_table :reportings do |t|
      t.references :user, foreign_key: true, index: true
      t.integer :reported_user_id

      t.timestamps
    end
  end
end
