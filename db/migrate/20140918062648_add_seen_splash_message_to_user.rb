class AddSeenSplashMessageToUser < ActiveRecord::Migration
  def change
    add_column :users, :has_seen_splash_message, :boolean, default: false
  end
end
