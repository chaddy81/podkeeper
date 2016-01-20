class CreateSiteComments < ActiveRecord::Migration
  def change
    create_table :site_comments do |t|
      t.integer :user_id
      t.text :body

      t.timestamps
    end

    add_index :site_comments, :user_id
  end
end
