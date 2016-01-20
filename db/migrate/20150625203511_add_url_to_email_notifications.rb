class AddUrlToEmailNotifications < ActiveRecord::Migration
  def change
    add_column :email_notifications, :url, :string
  end
end
