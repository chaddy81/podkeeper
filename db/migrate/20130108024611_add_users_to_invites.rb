class AddUsersToInvites < ActiveRecord::Migration
  def change
  	add_column :invites, :invitee_id, :integer
  	add_column :invites, :inviter_id, :integer
  end
end
