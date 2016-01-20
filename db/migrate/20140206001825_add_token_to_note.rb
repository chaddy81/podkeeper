class AddTokenToNote < ActiveRecord::Migration
  def change
    add_column :notes, :token, :string
  end
end
