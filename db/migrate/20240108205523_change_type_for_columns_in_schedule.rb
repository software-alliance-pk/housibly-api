class ChangeTypeForColumnsInSchedule < ActiveRecord::Migration[6.1]
  def change
    reversible do |direction|
      change_table :schedules do |t|
        direction.up { t.change :working_days, :string, array: true, default: [], using: 'working_days::character varying[]' }
        direction.down { t.change :working_days, :string, default: nil }

        direction.up { t.change :starting_time, :string }
        direction.down { t.change :starting_time, :datetime, using: 'starting_time::timestamp' }

        direction.up { t.change :ending_time, :string }
        direction.down { t.change :ending_time, :datetime, using: 'ending_time::timestamp' }
      end
    end
  end
end
