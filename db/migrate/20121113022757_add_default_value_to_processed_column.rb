class AddDefaultValueToProcessedColumn < ActiveRecord::Migration
  def up
    change_column :queuers, :processed, :boolean, :default => false
  end

  def down
     change_column :queuers, :processed, :boolean, :default => nil   
  end
end
