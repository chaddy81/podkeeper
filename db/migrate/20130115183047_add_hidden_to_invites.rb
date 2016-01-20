class AddHiddenToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :hidden, :boolean, default: false
  end
end
