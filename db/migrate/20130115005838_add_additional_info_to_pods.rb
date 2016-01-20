class AddAdditionalInfoToPods < ActiveRecord::Migration
  def change
    add_column :pods, :additional_info, :text
  end
end
