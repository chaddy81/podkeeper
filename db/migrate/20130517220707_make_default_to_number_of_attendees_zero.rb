class MakeDefaultToNumberOfAttendeesZero < ActiveRecord::Migration
  def change
    change_column :rsvps, :number_of_kids, :integer, default: 0
    change_column :rsvps, :number_of_adults, :integer, default: 0
  end
end
