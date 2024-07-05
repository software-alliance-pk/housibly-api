class CreatePreferenceProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :preference_properties do |t|
      t.references :user_preference, null: false, foreign_key: true
      t.references :property, null: false, foreign_key: true
      t.float :match_percentage

      t.timestamps
    end
  end
end
