class CardsController < AuthenticatedController
  
  helper :all

  include ActionView::Helpers::UrlHelper  
  include ActionController::UrlWriter

  include ApplicationHelper

  def index
    @cards ||= @project.cards
    respond_to do |format|  
      format.json { render :status => 200, :json => @cards }
    end    
  end
  
  def create
    if params[:card]
      @card ||= @project.cards.new(params[:card])
      if @card.save
        flash.now[:success] = "Card was saved successfully."
        @cards ||= @project.cards
        redirect_to (project_path(@project.id) + "?show_tab=0")
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
    position = {:left => params[:left].to_i, :top => params[:top].to_i}
    @board = @project.boards.find_by_name("backlog")
    @board ||= @project.boards.create(:name => "backlog")
    @board.update_card_position(params[:card_id], position)
    @board.save!
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
      format.html {render :partial => 'cards/colorbox_card'}
    end
  end
      
  def update
    @card ||= @project.cards.find(params[:id])
    params[:card][:user_id] = nil if params[:card][:user_id] == "unknown"
    @card.update_attributes(params[:card])
    respond_to do |format|
      format.html { render :action => 'show' }
      format.js { render :action => 'show'}
      format.json { render :json => @card.to_json }
    end
  end
  
  def destroy
    @card ||= @project.cards.find(params[:id])
    @card.project.cards.destroy(@card)
    respond_to do |format|
      format.js { render :status => 200, :json => "{\"card_id\":\"#{@card.id}\"}"}
    end
  end

  def update_attribute
    @card ||= @project.cards.find(params[:id])
    attribute = params[:attribute]
    @card.update_attributes({attribute.to_sym => params[:update_value]})
    @card.save!
    render :text => @card.send(attribute)    
  end
  
end
