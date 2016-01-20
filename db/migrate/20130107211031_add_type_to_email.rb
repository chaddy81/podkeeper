class AddTypeToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :email_type_id, :integer
  end
end
