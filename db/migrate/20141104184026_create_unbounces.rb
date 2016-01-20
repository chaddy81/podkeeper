class CreateUnbounces < ActiveRecord::Migration
  def change
    create_table :unbounces do |t|
      t.string :first_name
      t.string :string
      t.string :last_name
      t.string :email
      t.string :ip_address
      t.string :page_id
      t.string :page_name
      t.string :page_url
      t.string :page_variant

      t.timestamps
    end
  end
end
