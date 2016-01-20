class AddEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string

    User.all.each do |user|
        user.update_attribute(:email, user.default_email.email)
    end
  end
end
