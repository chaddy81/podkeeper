class AddUserAgentToEmailNotifications < ActiveRecord::Migration
  def change
    add_column :email_notifications, :useragent, :string
  end
end
