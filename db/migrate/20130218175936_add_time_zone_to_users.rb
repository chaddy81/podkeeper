class AddTimeZoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string

    User.all.each do |user|
      user.time_zone = "America/New_York"
      user.save
    end

  end
end
