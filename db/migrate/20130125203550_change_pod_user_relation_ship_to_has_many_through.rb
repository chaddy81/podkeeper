class ChangePodUserRelationShipToHasManyThrough < ActiveRecord::Migration
  def change
    drop_table :pods_users
  end
end
