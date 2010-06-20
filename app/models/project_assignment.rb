# == Schema Information
# Schema version: 20100613153258
#
# Table name: project_assignments
#
#  id         :integer         not null, primary key
#  user_id    :integer         
#  project_id :integer         
#

class ProjectAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
end
