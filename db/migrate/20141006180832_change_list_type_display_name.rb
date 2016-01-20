class ChangeListTypeDisplayName < ActiveRecord::Migration
  def change
    list = ListType.find_by_name("item_sign_up")
    list.update_column('display_name', 'Sign Up List')
  end
end
