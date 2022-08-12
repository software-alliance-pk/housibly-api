class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.references :user, foreign_key: true, index: true
      t.string :working_days
      t.datetime :starting_time
      t.datetime :ending_time

      t.timestamps
    end
  end
end
