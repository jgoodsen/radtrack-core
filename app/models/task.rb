# == Schema Information
# Schema version: 20091210081602
#
# Table name: tasks
#
#  id            :integer         not null, primary key
#  name          :string(255)     
#  task_state_id :integer         not null
#  card_id       :integer         
#  user_id       :integer         
#  created_at    :datetime        
#  updated_at    :datetime        
#  position      :integer         default(0)
#

class Task < ActiveRecord::Base

  belongs_to :card
  acts_as_list :scope => :card
  
  belongs_to :user
  belongs_to :task_state

  before_save do |record|
    record.task_state ||= record.card.project.default_task_state
  end

  def next_state
    current_index = card.project.task_states.index(task_state)
    self.task_state = card.project.task_states[current_index+1]
  end
  
  def previous_state
    current_index = card.project.task_states.index(task_state)
    self.task_state = card.project.task_states[current_index-1]
  end
  
  ## TODO: Rename task_state to state, so a task and a card have a uniform card interface for the kanban framework
  def state=(new_state)
    self.task_state = new_state
  end
  
  def state
    task_state
  end
  
  def to_json
    x = super
    raise x.inspect
  end
end
