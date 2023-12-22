class ChangeColumnTypesToArrayForUserPreference < ActiveRecord::Migration[6.1]
  def change
    reversible do |direction|
      change_table :user_preferences do |t|
        direction.up { t.change :driveway, :string, array: true, default: [], using: 'driveway::character varying[]' }
        direction.down { t.change :driveway, :string, default: nil }

        direction.up { t.change :water, :string, array: true, default: [], using: 'water::character varying[]' }
        direction.down { t.change :water, :string, default: nil }

        direction.up { t.change :sewer, :string, array: true, default: [], using: 'sewer::character varying[]' }
        direction.down { t.change :sewer, :string, default: nil }

        direction.up { t.change :pool, :string, array: true, default: [], using: 'pool::character varying[]' }
        direction.down { t.change :pool, :string, default: nil }

        direction.up { t.change :balcony, :string, array: true, default: [], using: 'balcony::character varying[]' }
        direction.down { t.change :balcony, :string, default: nil }

        direction.up { t.change :exposure, :string, array: true, default: [], using: 'exposure::character varying[]' }
        direction.down { t.change :exposure, :string, default: nil }

        direction.up { t.change :security, :string, array: true, default: [], using: 'security::character varying[]' }
        direction.down { t.change :security, :string, default: nil }

        direction.up { t.change :pets_allowed, :string, array: true, default: [], using: 'pets_allowed::character varying[]' }
        direction.down { t.change :pets_allowed, :string, default: nil }

        direction.up { t.change :laundry, :string, array: true, default: [], using: 'laundry::character varying[]' }
        direction.down { t.change :laundry, :string, default: nil }
      end
    end
  end

end
