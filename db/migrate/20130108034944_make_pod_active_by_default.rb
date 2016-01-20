class MakePodActiveByDefault < ActiveRecord::Migration
  def change
  	remove_column :users, :active
  	add_column :users, :active, :boolean, default: true
  	add_column :pods,  :active, :boolean, default: true
  end
end
