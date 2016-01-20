class AddDailyDigestToUser < ActiveRecord::Migration
  def change
    add_column :users, :daily_digest, :boolean, default: true
  end
end
