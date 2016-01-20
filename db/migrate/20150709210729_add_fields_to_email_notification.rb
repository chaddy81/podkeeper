class AddFieldsToEmailNotification < ActiveRecord::Migration
  def change
    add_column :email_notifications, :type, :string
    add_column :email_notifications, :status, :string
    add_column :email_notifications, :response, :string
    add_column :email_notifications, :reason, :string
    add_column :email_notifications, :category, :string
    add_column :email_notifications, :unique_arg_key, :string
    add_column :email_notifications, :attempt, :string
  end
end
