class AddPropertyReferenceToRoom < ActiveRecord::Migration[6.1]
  def change
    add_reference :rooms, :property, null: false, foreign_key: true
  end
end
