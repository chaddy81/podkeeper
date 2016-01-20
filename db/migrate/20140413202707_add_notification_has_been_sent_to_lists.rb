class AddNotificationHasBeenSentToLists < ActiveRecord::Migration
  def change
    add_column :lists, :notification_has_been_sent, :boolean, default: false
  end
end
