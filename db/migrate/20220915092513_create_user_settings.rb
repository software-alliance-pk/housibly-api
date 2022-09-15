class CreateUserSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :user_settings do |t|
      t.boolean :push_notification, default: true
      t.boolean :inapp_notification, default: true
      t.boolean :email_notification, default: true
      t.references :user, foreign_key: true, index:true

      t.timestamps
    end
  end
end
