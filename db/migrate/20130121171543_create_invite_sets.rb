class CreateInviteSets < ActiveRecord::Migration
  def change
    create_table :invite_sets do |t|

      t.timestamps
    end
  end
end
