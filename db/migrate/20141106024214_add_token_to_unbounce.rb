class AddTokenToUnbounce < ActiveRecord::Migration
  def change
    add_column :unbounces, :token, :string
  end
end
