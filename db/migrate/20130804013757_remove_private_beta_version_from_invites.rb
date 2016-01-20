class RemovePrivateBetaVersionFromInvites < ActiveRecord::Migration
  def change
    remove_column :invites, :private_beta_version
  end
end
