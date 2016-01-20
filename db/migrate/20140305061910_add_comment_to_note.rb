class AddCommentToNote < ActiveRecord::Migration
  def change
    add_column :notes, :comment_id, :integer
    add_index :notes, :comment_id
  end
end
