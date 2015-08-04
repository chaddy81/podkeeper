class UpdateRsvpOptionDisplayNames < ActiveRecord::Migration
  def change
    RsvpOption.find_by_name('yes').update_column(:display_name, "I'll be there")
    RsvpOption.find_by_name('no').update_column(:display_name, "Can't make it")
  end
end
