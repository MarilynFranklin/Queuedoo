class AddUserIdToQueuers < ActiveRecord::Migration
  def change
    add_column :queuers, :user_id, :integer
  end
end
