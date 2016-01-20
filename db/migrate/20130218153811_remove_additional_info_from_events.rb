class RemoveAdditionalInfoFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :additional_info
  end
end
