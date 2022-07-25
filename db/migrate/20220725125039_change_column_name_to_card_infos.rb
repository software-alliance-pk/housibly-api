class ChangeColumnNameToCardInfos < ActiveRecord::Migration[6.1]
  def change
    rename_column :card_infos, :id_default, :is_default
  end
end
