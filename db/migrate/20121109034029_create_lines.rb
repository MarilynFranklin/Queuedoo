class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :title
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :time_slot_estimate

      t.timestamps
    end
  end
end
