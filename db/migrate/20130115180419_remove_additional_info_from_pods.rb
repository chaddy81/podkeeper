class RemoveAdditionalInfoFromPods < ActiveRecord::Migration
  def change
  	remove_column :pods, :additional_info
  	remove_column :pods, :description
  	add_column :pods, :description, :text
  end
end
