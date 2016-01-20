class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.integer :user_id
      t.string :file
      t.string :url
      t.string :description

      t.timestamps
    end
  end
end
