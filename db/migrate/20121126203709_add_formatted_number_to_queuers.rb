class AddFormattedNumberToQueuers < ActiveRecord::Migration
  def change
    add_column :queuers, :formatted_number, :string
  end
end
