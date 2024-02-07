class AddEventTypeToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :event_type, :string
  end
end
