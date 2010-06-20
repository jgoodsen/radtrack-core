# == Schema Information
# Schema version: 20100613153258
#
# Table name: card_views
#
#  id         :integer         not null, primary key
#  project_id :integer         
#  user_id    :integer         
#  name       :string(255)     
#  data       :text            
#  created_at :datetime        
#  updated_at :datetime        
#

## A CardView is basically a loose association of client data between a project and a user that is typically used to
## record and restore a particular layout of cards.  For example, the default card cluster view on the backlog tab uses
## CardViews to save/restore the positions of cards on the backlog
class CardView < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
end
