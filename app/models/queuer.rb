class Queuer < ActiveRecord::Base
  attr_accessible :line_id, :name, :phone, :processed
  
  validates_presence_of :name

  belongs_to :line

  before_save :set_place_in_line

  def set_place_in_line
    self.place_in_line ||= self.line.next_spot
  end

  def process!
    self.processed = true
    save!
    line.move_up_queuers
  end
end
