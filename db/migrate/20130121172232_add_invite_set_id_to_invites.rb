class AddInviteSetIdToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :invite_set_id, :integer
  end
end
