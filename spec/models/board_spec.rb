require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "class Board" do
  
  describe "method update_card_positions" do
  
    it "should update the card_positions_json" do
      @board = Board.new(:card_positions_json => "[]")
      @board.update_card_position(1, {:top => 20, :left => 30})
      @board.update_card_position(2, {:top => 25, :left => 35})
      expected_card_positions = [
        {"id" => "1", "position" => {"top" => 20, "left" => 30}}, 
        {"id" => "2", "position" => {"top" => 25, "left" => 35}}, 
      ]
      ActiveSupport::JSON.decode(@board.card_positions_json).should == expected_card_positions
    end
  
    it "should not duplicate entries for a card in the card_positions array" do
      @board = Board.new(:card_positions_json => "[]")
      @board.update_card_position(1, {:top => 20, :left => 30})
      @board.update_card_position(1, {:top => 25, :left => 35})
      expected_card_positions = [
        {"id" => "1", "position" => {"top" => 25, "left" => 35}}, 
      ]
      ActiveSupport::JSON.decode(@board.card_positions_json).should == expected_card_positions
    end

    it "should return an empty array when nil" do
      @board = Board.new(:card_positions_json => nil)
      @board.card_positions.should == []
    end
    
  end
  
  it "should always have unique board names within a project" do
    @project = Factory.create(:project)
    @board1 = @project.boards.create(:name => 'Board One')
    lambda { @project.boards.create(:name => 'Board One')}.should raise_error
  end

  it "should allow the same board name across different projects" do
    Factory.create(:project).boards.create(:name => "Testing Same Board Names")
    Factory.create(:project).boards.create(:name => "Testing Same Board Names")
    Board.all.size.should == 2
  end
  
end
