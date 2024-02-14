class AddPropertyReferenceToNotification < ActiveRecord::Migration[6.1]
  def change
    add_reference :notifications, :property, null: true, foreign_key: true
  end
end
