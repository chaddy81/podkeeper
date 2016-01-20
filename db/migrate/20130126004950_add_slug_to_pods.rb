class AddSlugToPods < ActiveRecord::Migration
  def change
    add_column :pods, :slug, :string
  end
end
