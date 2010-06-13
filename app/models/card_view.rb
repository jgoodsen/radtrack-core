## A CardView is basically a loose association of client data between a project and a user that is typically used to
## record and restore a particular layout of cards.  For example, the default card cluster view on the backlog tab uses
## CardViews to save/restore the positions of cards on the backlog
class CardView < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
end
