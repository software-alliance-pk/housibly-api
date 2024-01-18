class RenameOriginAndRemoveRadiusFromSavedSearch < ActiveRecord::Migration[6.1]
  def change
    change_table :saved_searches do |t|
      t.rename :origin, :circle

      reversible do |direction|
        direction.up { t.remove :radius }
        direction.down { t.float :radius }
      end
    end
  end
end
