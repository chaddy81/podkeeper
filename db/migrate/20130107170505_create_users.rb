class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :password_digest
      t.string :zipcode
      t.string :gender
      t.date :birth_date
      t.string :username
      t.boolean :active
      t.datetime :last_login
      t.string :email

      t.timestamps
    end
  end
end
