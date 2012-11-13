class AddProcessedToQueuer < ActiveRecord::Migration
  def change
    add_column :queuers, :processed, :boolean
  end
end
