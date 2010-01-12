require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "factory girl" do
  it "should create a simple project" do
    p = create_simple_project
    p.name.should =~ /Project_[\d+]/
    p.users.size.should == 2
    p.cards.size.should == 3
    p.cards[0].owner.name.should == "Frank"
    p.cards[1].owner.name.should == "Joe"
  end
end

  
