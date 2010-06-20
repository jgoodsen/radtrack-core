class Board < ActiveRecord::Base
    
    def card_positions
      @card_positions = ActiveSupport::JSON.decode(self.card_positions_json)
    end
    
    def update_card_position(id, position)
      @card_positions = ActiveSupport::JSON.decode(self.card_positions_json)
      @card_positions << {:id => id.to_s, :position => position}
      self.card_positions_json = @card_positions.to_json
    end
  
end
