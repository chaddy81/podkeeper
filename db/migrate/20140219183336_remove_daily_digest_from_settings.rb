class RemoveDailyDigestFromSettings < ActiveRecord::Migration
  def change
    remove_column :settings, :daily_digest
  end
end
