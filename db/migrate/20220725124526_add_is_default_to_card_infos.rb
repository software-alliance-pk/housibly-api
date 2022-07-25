class AddIsDefaultToCardInfos < ActiveRecord::Migration[6.1]
  def change
    add_column :card_infos, :id_default, :boolean
    remove_column :card_infos, :number
    remove_column :card_infos, :cvc
  end
end
