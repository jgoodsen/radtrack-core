class CardsController < AuthenticatedController
  
  helper :all
  include ActionView::Helpers::UrlHelper  
  include ActionController::UrlWriter

  include ApplicationHelper
    
  def index
    @cards ||= @project.cards
    respond_to do |format|
      
      format.json { 
        # card_positions = { '490' => {:top => 50, :left => 80} }
        card_positions = session[:backlog_card_positions] ? session[:backlog_card_positions] : {}
        cards_json = @cards.collect{ |c| 
          id = c.id.to_s
          tasks_json = c.tasks.collect { |t|
            {:name => t.name, :task_state_id => t.task_state_id}
          }
          position = card_positions[id].nil? ? {} : {:top => card_positions[id][:top].to_i, :left => card_positions[id][:left].to_i}
          { :card => c.attributes.merge(:owner => {:id => c.owner.id, :name => c.owner.name}, :tasks => tasks_json).merge(position) } 
        }
        render :status => 200, :json => cards_json
      }
    end    
  end
  
  def create
    if params[:card]
      @card ||= @project.cards.new(params[:card])
      if @card.save
        flash.now[:success] = "Card was saved successfully."
        @cards ||= @project.cards
        redirect_to (project_path(@project.id) + "#backlog_tab")
      else
        flash.now[:error] << "Card creation failed."
        render :action => 'new'
      end
    end

  end
  
  def activate
    project = current_user.projects.find(params[:project_id])
    card = project.cards.find(params[:card_id])
    card.card_state = project.card_states.first
    card.save!
    respond_to do |format|
      format.json { render :status => 200, :json => card }
    end    
  end

  def backlog_card_drop
    session[:backlog_card_positions] ||= {}
    position = {:left => params[:left].to_i, :top => params[:top].to_i}
    session[:backlog_card_positions][params[:card_id]] = position
    respond_to do |format|
      format.json { render :status => 200, :json => position }
    end    
  end
  
  def move_to_backlog
    @card.card_state = nil
    if @card.save
      respond_to do |format|
        format.json { render :status => 200, :json => @card }
      end    
    else
      ## TODO: return error status here
    end
  end
  
  def show
    @card ||= @project.cards.find(params[:id])
    respond_to do |format|
      format.html { raise "HTML View of a Card is not yet implemented" }
      format.js
      format.json { render :json => @card.to_json(:include => [:tasks]) }
    end
  end
  
  def update
    @card ||= @project.cards.find(params[:id])
    params[:card][:user_id] = nil if params[:card][:user_id] == "unknown"
    @card.update_attributes(params[:card])
    respond_to do |format|
      format.html { render :action => 'show' }
      format.js { render :action => 'show'}
      format.json { render :json => @card.to_json(:include => :owner) }
    end
  end
  
  def destroy
    @card ||= @project.cards.find(params[:id])
    @card.project.cards.destroy(@card)
    respond_to do |format|
      format.html { raise "Delete card is only accepted for AJAX requests right now." }
      format.js { render :status => 200, :json => "{\"card_id\":\"#{@card.id}\"}"}
    end
  end

end
