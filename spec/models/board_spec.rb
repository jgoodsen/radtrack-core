require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Board" do
  
  it "should return a string that can be saved in a CardView" do
    @project = new_project
    @board = Board.new(@project, :test_board)
    @board.update_card_position(1, {:top => 20, :left => 30})
    @board.update_card_position(2, {:top => 25, :left => 35})
    expected_card_positions = {1 => {:top => 20, :left => 30}, 2 => {:top => 25, :left => 35}}
    @board.card_positions.should == expected_card_positions
    @board.to_jso.should == {1 => {:top => 20, :left => 30}, 2 => {:top => 25, :left => 35}}.to_json
  end
  
  
end
