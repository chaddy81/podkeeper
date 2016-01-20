class RemoveUnusedFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :zipcode
    remove_column :users, :gender
    remove_column :users, :birth_date
    remove_column :users, :username
  end
end
