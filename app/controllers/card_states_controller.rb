class CardStatesController < AuthenticatedController
  
  def create
    
    if params[:card_state]
      @x ||= @project.card_states.new(params[:card_state])
      @x.save!
      respond_to do |format|
        format.html { render :partial => 'card_states/card_state', :locals => {:card_state => @x} }
      end
    end

  end
  
  def destroy
    @x = @project.card_states.find(params[:id])
    @x.destroy if @x
    respond_to do |format|
      format.json { render :json => @x}  
    end
  end
    
  def dropped
    # "card_state[]=139&card_state[]=137&card_state[]=140&card_state[]=141&card_state[]=143"
    ids = params[:card_states].split('&').collect do |x| x =~ /card_state\[\]=(.*)/ ; $1 end
    
    ids.each_with_index do |id, index|
      card_state  = @project.card_states.find(id)
      card_state.update_attributes(:position => index+1)
    end
    render :text => '', :layout => false
    
  end
  
end
