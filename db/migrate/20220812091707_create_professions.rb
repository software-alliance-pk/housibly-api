class CreateProfessions < ActiveRecord::Migration[6.1]
  def change
    create_table :professions do |t|
      t.references :user, foreign_key: true, index: true
      t.string :title

      t.timestamps
    end
  end
end
