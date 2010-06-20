# == Schema Information
# Schema version: 20100613153258
#
# Table name: users
#
#  id                        :integer         not null, primary key
#  login                     :string(40)      
#  name                      :string(100)     default("")
#  email                     :string(100)     
#  admin                     :boolean         
#  created_at                :datetime        
#  updated_at                :datetime        
#  remember_token            :string(40)      
#  remember_token_expires_at :datetime        
#  activation_code           :string(40)      
#  activated_at              :datetime        
#  persistence_token         :string(255)     
#  perishable_token          :string(255)     default(""), not null
#  login_count               :integer         default(0), not null
#  failed_login_count        :integer         default(0), not null
#  current_login_at          :datetime        
#  current_login_ip          :string(255)     
#  last_login_at             :datetime        
#  last_login_ip             :string(255)     
#  crypted_password          :string(128)     default(""), not null
#  salt                      :string(128)     default(""), not null
#

class User < ActiveRecord::Base
  
  before_save :mirror_email_as_login
  
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::Sha1
    c.validates_length_of_password_field_options :minimum => 6, :if => :require_password?
  end
  
  has_many :project_assignments
  has_many :projects, :through => :project_assignments
  has_many :tasks

  has_many :cards
  
  def self.create_admin_user
    u = User.create!({:admin => true, :login => 'admin@radtrack.com', :email => 'admin@radtrack.com', :password => 'monkey', :password_confirmation => 'monkey', :name => 'Administrator', :admin => 1})
  end
  
  def self.create_guest_user
    u = User.find_by_login 'guest'
    u ||= User.create! :login => 'guest@radtrack.com', :email => 'guest@radtrack.com', :password => 'password', :password_confirmation => 'password'
  end
    
  def deliver_added_to_project_notification(project, from_user)
    reset_perishable_token!
    Notifier.deliver_added_to_project_notification(self, project, from_user)
  end
    
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  def deliver_project_invitation(project, from_user)
    reset_perishable_token!
    Notifier.deliver_project_invitation(self, project, from_user)
  end
  
  def current_project
    projects.first
  end

  def name
    read_attribute(:name).empty? ? login : read_attribute(:name)
  end
  
  def active_tasks
    tasks.select{ |x| x.task_state.name == 'Started' }
  end
  
  def unstarted_tasks
    tasks.select{ |x| x.task_state.name == TaskState::NOT_STARTED }
  end
  
  def finished_tasks
    tasks.select{ |x| x.task_state.name == TaskState::FINISHED }
  end
  
  def admin? 
    self.admin
  end

  def disassociate_from_project(project)
    projects.delete(project)
    project.users.delete(self)
    disassociate_tasks_for_project(project)
    disassociate_cards_for_project(project)
  end

  def disassociate_tasks_for_project(project)
    if tasks_for_project = cards.by_project(project).tasks #returns nil if nil.tasks
      tasks.delete(tasks_for_project)
    end
  end

  def disassociate_cards_for_project(project)
    cards.delete(cards.by_project(project))  
  end
  
  def mirror_email_as_login
    self.login = self.email
  end
  
end
