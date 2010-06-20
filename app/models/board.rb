class Board

  attr_accessor :project, :name, :card_positions, 
  
  def initialize(project, identifier)
    @project = project
    @identifier = identifier
    @card_positions = {} ## Hashed by card_id => position
    @card_view = @project.card_views.find_by_name(identifier.to_s)
  end
  
  def update_card_position(id, position)
    @card_positions[id] = position
  end
    
end
