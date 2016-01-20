class DropInviteSets < ActiveRecord::Migration
  def change
  	drop_table :invite_sets
  end
end
