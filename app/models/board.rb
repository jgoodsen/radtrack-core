class Board

  attr_accessor :project, :name
  
  def initialize(project, name)
    @project = project
    @name = name
    @card_positions = {} ## Hashed by card_id => position
  end
  
  def update_card_position(id, position)
    @card_positions[id.to_sym] = position
  end
  
  def to_s
  end
  
end
