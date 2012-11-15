class AddUserIdToLines < ActiveRecord::Migration
  def change
    add_column :lines, :user_id, :integer
  end
end
