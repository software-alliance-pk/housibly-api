class AddLastSeenToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :last_seen, :boolean, default: false
  end
end
