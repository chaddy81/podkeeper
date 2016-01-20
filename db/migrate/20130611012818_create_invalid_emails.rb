class CreateInvalidEmails < ActiveRecord::Migration
  def change
    create_table :invalid_emails do |t|
      t.integer :pod_id
      t.integer :user_id
      t.string :email

      t.timestamps
    end

    add_index :invalid_emails, :pod_id
    add_index :invalid_emails, :user_id
  end
end
