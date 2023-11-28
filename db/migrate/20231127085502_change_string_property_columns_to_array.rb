class ChangeStringPropertyColumnsToArray < ActiveRecord::Migration[6.1]
  def change
    reversible do |direction|
      change_table :properties do |t|
        direction.up { t.change :basement, :string, array: true, default: [], using: 'basement::character varying[]' }
        direction.down { t.change :basement, :string, default: nil }

        direction.up { t.change :exterior, :string, array: true, default: [], using: 'exterior::character varying[]' }
        direction.down { t.change :exterior, :string, default: nil }

        direction.up { t.change :heat_source, :string, array: true, default: [], using: 'heat_source::character varying[]' }
        direction.down { t.change :heat_source, :string, default: nil }

        direction.up { t.change :heat_type, :string, array: true, default: [], using: 'heat_type::character varying[]' }
        direction.down { t.change :heat_type, :string, default: nil }

        direction.up { t.change :fireplace, :string, array: true, default: [], using: 'fireplace::character varying[]' }
        direction.down { t.change :fireplace, :string, default: nil }

        direction.up { t.change :air_conditioner, :string, array: true, default: [], using: 'air_conditioner::character varying[]' }
        direction.down { t.change :air_conditioner, :string, default: nil }

        direction.up { t.change :included_utilities, :string, array: true, default: [], using: 'included_utilities::character varying[]' }
        direction.down { t.change :included_utilities, :string, default: nil }
      end
    end
  end
end
