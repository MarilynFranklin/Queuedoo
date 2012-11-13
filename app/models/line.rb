class Line < ActiveRecord::Base
  attr_accessible :end_time, :start_time, :time_slot_estimate, :title
  
  validates_presence_of :title

  has_many :queuers
  has_many :unprocessed_queuers, class_name: "Queuer", conditions: { processed: false }

  def next_spot
    unprocessed_queuers.size + 1
  end

  def move_up_queuers
    unprocessed_queuers.each do |queuer|
      queuer.place_in_line -= 1
      queuer.save!
    end
  end
end
