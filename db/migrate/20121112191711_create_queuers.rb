class CreateQueuers < ActiveRecord::Migration
  def change
    create_table :queuers do |t|
      t.string :name
      t.string :phone
      t.integer :line_id

      t.timestamps
    end
  end
end
