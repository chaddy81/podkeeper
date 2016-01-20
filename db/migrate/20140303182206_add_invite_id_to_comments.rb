class AddInviteIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :invite_id, :integer
    add_index :comments, :invite_id
  end
end
