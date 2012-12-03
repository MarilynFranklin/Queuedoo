class Line < ActiveRecord::Base
  attr_accessible :end_time, :start_time, :time_slot_estimate, :title
  
  validates_presence_of :title

  has_many :queuers
  has_many :unprocessed_queuers, class_name: "Queuer", conditions: { processed: false }, order: "place_in_line ASC"

  belongs_to :user

  def first_queuer
    unprocessed_queuers.find_by_place_in_line(1)
  end

  def move_up_queuers_behind(queuer)
    queuer.next_queuers.each do |queuer|
      queuer.place_in_line -= 1
      queuer.save!
    end
  end

  def next_spot
    number_of_queuers + 1
  end

  def number_of_queuers
    unprocessed_queuers.size
  end
end
