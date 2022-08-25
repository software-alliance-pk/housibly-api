class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true, index:true
      t.text :description
      t.integer :rating

      t.timestamps
    end
  end
end
