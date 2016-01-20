class RemoveInviteSetIdFromInvites < ActiveRecord::Migration
  def up
    remove_column :invites, :invite_set_id
  end

  def down
    add_column :invites, :invite_set_id, :string
  end
end
