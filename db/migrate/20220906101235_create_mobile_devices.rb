class CreateMobileDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :mobile_devices do |t|
      t.string :mobile_device_token
      t.references :user, foreign_key: true, index:true

      t.timestamps
    end
  end
end
