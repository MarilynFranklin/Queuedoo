class Queuer < ActiveRecord::Base
  attr_accessible :line_id, :name, :phone
  
  belongs_to :line
end
