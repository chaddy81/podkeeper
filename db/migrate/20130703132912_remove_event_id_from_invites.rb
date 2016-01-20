class RemoveEventIdFromInvites < ActiveRecord::Migration
  def up
    remove_column :invites, :event_id
  end

  def down
    add_column :invites, :event_id, :string
  end
end
