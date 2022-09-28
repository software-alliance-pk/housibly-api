class AddWeightAgeToProperty < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :weight_age, :string
  end
end
