# == Schema Information
# Schema version: 20091210081602
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  name       :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#

class Project < ActiveRecord::Base
  
  has_many :project_assignments
  has_many :users, :through => :project_assignments
  
  has_many :cards, :dependent => :delete_all, :order => 'position'
  
  has_many :task_states
  has_many :card_states, :dependent => :delete_all, :order => 'position'
  has_many :activity_log_entries
  
  after_save :ensure_initial_card_states
  after_save :ensure_initial_task_states
    
  validates_presence_of :name, :message => "can't be blank"
  
  def card_types
    CardType.all
  end
  
  def default_card_type
    CardType.find(:first, :conditions => {:name => 'User Story'})
  end
  
  def default_task_state
    @@default_task_state ||= task_states.first
  end

  def kanban_tasks_for(user)
    raise "User is not a member of project: #{name}" unless users.include?(user)
    kanban_tasks.select {|t| user == t.user}
  end
  
  def kanban_tasks
    kanban_cards.collect(&:tasks).flatten
  end
  
  def kanban_cards
    kanban_states = [card_states[1]] ## TODO: Make user definable
    cards.select{|c| kanban_states.include?(c.card_state)}
  end
  
  def owners
    self.users
  end
  
  def remove_user(user)
    raise "Cannot remove the only admin user of a project." if last_admin?(user)
    self.users.delete(user)
    user.projects.delete(self)
    user.tasks.select{|t| t.card.project == self}.each do |task|
      user.tasks.delete(task)
      task.save!
    end
    user.save!
    self.save!
  end
  
  def admin_users
    users.select{|u| u.admin?}
  end
  
  private
    
    def last_admin?(user)
      user.admin? ? self.admin_users.size == 1 && self.admin_users.first == user : false
    end
    
    def ensure_initial_card_states
      if self.card_states.empty?
        self.card_states.create({:name => 'Requested'})
        self.card_states.create({:name => 'In Progress'})
        self.card_states.create({:name => 'Delivered'})
        self.card_states.create({:name => 'Accepted'})
      end
    end

    def ensure_initial_task_states
      if task_states.empty?
        task_states.create! :name => TaskState::NOT_STARTED
        task_states.create! :name => TaskState::STARTED
        task_states.create! :name => TaskState::FINISHED
      end
    end

end
