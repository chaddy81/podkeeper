class AddIpToEmailNotifications < ActiveRecord::Migration
  def change
    add_column :email_notifications, :ip, :string
  end
end
