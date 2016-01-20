class CreateListTypes < ActiveRecord::Migration
  def change
    create_table :list_types do |t|
      t.string :name
      t.string :display_name

      t.timestamps
    end
  end
end
