class CreateSupportMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :support_messages do |t|
      t.text :body
      t.references :user, foreign_key: true, index:true
      t.references :support_conversation, foreign_key: true, index: true

      t.timestamps
    end
  end
end
