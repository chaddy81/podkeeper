class AddPrivateBetaVersionToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :private_beta_version, :boolean, default: false
  end
end
