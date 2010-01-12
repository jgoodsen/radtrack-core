class Card < ActiveRecord::Base

  belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
  belongs_to :project
  acts_as_list :scope => :project

  belongs_to :card_type
  belongs_to :card_state
  
  has_many :tasks, :order => 'position', :dependent => :delete_all
    
  validates_presence_of :project, :message => 'A Card must always belong to a project'

  named_scope :by_project, lambda { |project| { :conditions => {:project_id => project.id} } } do
    def tasks
      map!{|card| card.tasks}.flatten!
    end
  end

  def task_states
    project.task_states
  end
  
  def name
    title
  end
  def state
    card_state
  end
  def state=(new_state)
    self.card_state = new_state
  end
  
  def to_json(options = {}) 
    super(options.merge(:include => [:tasks, :owner]))
  end

  def owner
    user_id ? User.find(user_id) : User.new(:name => "Owner is unassigned")
  end
  
  def move_to_backlog
    self.card_state = nil
  end
    
  def activate!
    self.card_state = self.project.card_states.first
  end
  
  private
  
end
