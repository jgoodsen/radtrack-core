require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Board" do
  
  it "should update the card_positions_json" do
    @board = create_board()
    @board.update_card_position(1, {:top => 20, :left => 30})
    @board.update_card_position(2, {:top => 25, :left => 35})
    expected_card_positions = {"1" => {"top" => 20, "left" => 30}, "2" => {"top" => 25, "left" => 35}}
    ActiveSupport::JSON.decode(@board.card_positions_json).should == expected_card_positions
  end
  
  
end
