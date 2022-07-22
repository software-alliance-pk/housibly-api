class AddUserIdToCardInfo < ActiveRecord::Migration[6.1]
  def change
    add_reference :card_infos, :user, null: false, foreign_key: true
  end
end
