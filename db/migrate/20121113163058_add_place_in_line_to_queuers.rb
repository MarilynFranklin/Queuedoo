class AddPlaceInLineToQueuers < ActiveRecord::Migration
  def change
    add_column :queuers, :place_in_line, :integer
  end
end
