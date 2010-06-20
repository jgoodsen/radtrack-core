# == Schema Information
# Schema version: 20100613153258
#
# Table name: task_states
#
#  id         :integer         not null, primary key
#  name       :string(255)     
#  project_id :integer         
#  created_at :datetime        
#  updated_at :datetime        
#

class TaskState < ActiveRecord::Base

  STARTED = 'Started'
  NOT_STARTED = 'Not Started'
  FINISHED = 'Finished'

  ## TODO: Rename the state column of both a Task and a Card to just be a State object.
  def state
    card_state
  end
  
  def state=(new_state)
    self.card_state = new_state
  end

  def started?
    name == STARTED
  end
  
end
