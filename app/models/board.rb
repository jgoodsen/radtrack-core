class Board < ActiveRecord::Base
    
    def card_positions
      @card_positions = ActiveSupport::JSON.decode(self.card_positions_json)
    end
    
    def update_card_position(id, position)
      @card_positions = ActiveSupport::JSON.decode(self.card_positions_json)
      replace_position_for(id, position)
      self.card_positions_json = @card_positions.as_json
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
    
end
