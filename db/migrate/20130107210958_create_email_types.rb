class CreateEmailTypes < ActiveRecord::Migration
  def change
    create_table :email_types do |t|
      t.string :name
      t.string :display_name

      t.timestamps
    end
  end
end
