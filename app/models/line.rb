class Line < ActiveRecord::Base
  attr_accessible :end_time, :start_time, :time_slot_estimate, :title
  
  validates_presence_of :title

  has_many :queuers
end
