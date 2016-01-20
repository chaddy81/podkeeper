class AddDeclinedToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :declined, :boolean, default: false
    remove_column :invites, :deleted_at
  end
end
