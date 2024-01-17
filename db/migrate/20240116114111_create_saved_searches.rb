class CreateSavedSearches < ActiveRecord::Migration[6.1]
  def change
    create_table :saved_searches do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :search_type
      t.json :polygon
      t.json :origin
      t.float :radius
      t.string :title
      t.string :display_address
      t.string :zip_code

      t.timestamps
    end
  end
end
