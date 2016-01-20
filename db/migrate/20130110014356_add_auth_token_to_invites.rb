class AddAuthTokenToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :auth_token, :string
  end
end
