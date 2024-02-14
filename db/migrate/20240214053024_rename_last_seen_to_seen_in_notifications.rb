class RenameLastSeenToSeenInNotifications < ActiveRecord::Migration[6.1]
  def change
    rename_column :notifications, :last_seen, :seen
  end
end
