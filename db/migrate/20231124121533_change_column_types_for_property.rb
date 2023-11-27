class ChangeColumnTypesForProperty < ActiveRecord::Migration[6.1]
  def change
    reversible do |direction|
      change_table :properties do |t|
        direction.up { t.change :central_vacuum, 'boolean USING CAST(central_vacuum AS boolean)' }
        direction.up { t.change :bed_rooms, 'integer USING CAST(bed_rooms AS integer)' }
        direction.up { t.change :bath_rooms, 'integer USING CAST(bath_rooms AS integer)' }
        direction.up { t.change :garage_spaces, 'integer USING CAST(garage_spaces AS integer)' }
        direction.up { t.change :property_tax, :float }

        direction.down { t.change :central_vacuum, :string }
        direction.down { t.change :bed_rooms, :string }
        direction.down { t.change :bath_rooms, :string }
        direction.down { t.change :garage_spaces, :string }
        direction.down { t.change :property_tax, :integer }
      end
    end
  end
end
