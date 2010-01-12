class AuthenticatedController < ApplicationController
  
  before_filter :require_user, :get_project, :get_card
  
  protected
  
    def get_card
      @card = Card.find(params[:card_id]) if params[:card_id]
    end
    
    def get_project
      @project = Project.find(params['project_id']) if params['project_id']
    end
    
end
