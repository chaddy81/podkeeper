class AddSortByDateToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :sort_by_date, :datetime

    Note.all.each do |note|
      note.update_attribute(:sort_by_date, note.updated_at)
    end
  end
end
