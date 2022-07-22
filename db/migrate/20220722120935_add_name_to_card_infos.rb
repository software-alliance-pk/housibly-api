class AddNameToCardInfos < ActiveRecord::Migration[6.1]
  def change
    add_column :card_infos, :name, :string
  end
end
