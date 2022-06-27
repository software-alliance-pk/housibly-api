class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :password
      t.string :phone_number
      t.text :description
      t.boolean :licensed_realtor, default: false
      t.boolean :contacted_by_real_estate, default: false
      t.integer :user_type
      t.integer :profile_type

      t.timestamps
    end
  end
end
