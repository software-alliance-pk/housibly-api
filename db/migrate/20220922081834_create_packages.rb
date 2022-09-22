class CreatePackages < ActiveRecord::Migration[6.1]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :price
      t.string :stripe_package_id
      t.string :stripe_price_id

      t.timestamps
    end
  end
end
