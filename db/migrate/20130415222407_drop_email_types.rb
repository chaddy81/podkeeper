class DropEmailTypes < ActiveRecord::Migration
  def change
  	drop_table :email_types
  end
end
