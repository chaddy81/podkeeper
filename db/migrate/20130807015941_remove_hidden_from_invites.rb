class RemoveHiddenFromInvites < ActiveRecord::Migration
  def change
    remove_column :invites, :hidden
  end
end
