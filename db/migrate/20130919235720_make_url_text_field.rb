class MakeUrlTextField < ActiveRecord::Migration
  def change
    remove_column :uploaded_files, :url
    add_column :uploaded_files, :url, :text
  end
end
