class AddAccceptedToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :accepted, :boolean, default: false
  end
end
