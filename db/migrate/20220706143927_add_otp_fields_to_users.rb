class AddOtpFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :reset_signup_token, :string
    add_column :users, :reset_signup_token_sent_at, :datetime
  end
end
