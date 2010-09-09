class Board < ActiveRecord::Base
    
    belongs_to :project
    
    named_scope :for_project, lambda { |project|
          { :conditions => { :project_id => project.id } }
    }
          
    before_create :ensure_no_duplicate_names
    
    def initialize(attributes)
      super(attributes)
      self.card_positions_json ||= "[]"
      @card_positions ||= []
    end
    
    def card_positions
      @card_positions = ActiveSupport::JSON.decode(self.card_positions_json)
    end
    
    def update_card_position(id, position)
      self.card_positions_json ||= "[]"
      @card_positions = ActiveSupport::JSON.decode(self.card_positions_json)
      replace_position_for(id, position)
      self.card_positions_json = @card_positions.to_json
    end

  private
  
    def replace_position_for(id, position)
      @card_positions.each_with_index do |entry, index|
        if (entry["id"] == id.to_s)
          return @card_positions[index] = make_position_entry(id, position)
        end
      end
      @card_positions << make_position_entry(id, position)
    end
    
    def make_position_entry(id, position)
      return {:id => id.to_s, :position => position}
    end
    
    def ensure_no_duplicate_names
      raise "Duplicate Board Name Error" if Board.for_project(self.project).boards.find_by_name(self.name)
    end
    
end
