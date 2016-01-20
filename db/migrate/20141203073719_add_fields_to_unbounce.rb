class AddFieldsToUnbounce < ActiveRecord::Migration
  def change
    add_column :unbounces, :utm_source, :string
    add_column :unbounces, :utm_medium, :string
    add_column :unbounces, :utm_content, :string
    add_column :unbounces, :utm_campaign, :string
  end
end
