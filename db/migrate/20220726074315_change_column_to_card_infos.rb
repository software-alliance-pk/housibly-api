class ChangeColumnToCardInfos < ActiveRecord::Migration[6.1]
  def change
    change_column :card_infos, :is_default, :boolean, default: false
  end
end
