class AddTextToJoinToLines < ActiveRecord::Migration
  def change
    add_column :lines, :text_to_join, :boolean
  end
end
