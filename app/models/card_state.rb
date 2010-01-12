## This class represents an activity in the value stream (e.g. a swimlane on the kanban board)
## TODO: Should probably rename this class to Activity or Swimlane
class CardState < ActiveRecord::Base
  
  belongs_to :project
  has_many :cards, :dependent => :nullify
  
  acts_as_list :scope => :project
  
end
