class Queuer < ActiveRecord::Base
  attr_accessible :line_id, :name, :phone
  
  validates_presence_of :name

  belongs_to :line
end
