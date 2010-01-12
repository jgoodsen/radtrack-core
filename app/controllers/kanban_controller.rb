class KanbanController < AuthenticatedController

  def card_dropped
    card_ids = params[:cards].split('&').collect do |x| x =~ /card\[\]=(.*)/ ; $1 end
    key = params[:card_state].gsub("card_state_", "")
    new_state = @project.card_states.find_by_id(key)
    new_state.cards.clear if new_state
    card_ids.each_with_index do |id, index|
      card  = @project.cards.find(id)
      new_state ? new_state.cards << card : card.card_state = nil
      card.update_attribute(:position, index)
      card.save!
    end
    render :text => '', :layout => false
  end
  
end
