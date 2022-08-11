class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.string :bookmark_type
      t.references :user, foreign_key: true, index: true
      t.references :property, foreign_key: true, index: true

      t.timestamps
    end
  end
end
