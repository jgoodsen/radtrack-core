require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe CardState do
  
  before(:each) do
    @project = create_project()
  end
  
  it "should only allow alphanumerics, spaces, ampersands,dashes and underscores for a name" do
    @project.card_states.build(:name => "Project ABC DEF-XYZ_123324").should be_valid
    @project.card_states.build(:name => "-").should be_valid
    @project.card_states.build(:name => "_").should be_valid
    @project.card_states.build(:name => "Project & X").should be_valid
  end
    
  it "should enforce a limit to the name length" do
    @project.card_states.build(:name => "A valid name").should be_valid
    @project.card_states.build(:name => "a really long name"*200).should_not be_valid
  end
  
  it "should not let the name be empty" do
    @project.card_states.build(:name => '').should_not be_valid
  end

  it "all cards that used to have this state, should have null for their cardstate after the cardstate is removed" do
    @card_state = @project.card_states.create(:name => "ActivityOne")
    @card = @project.cards.create(:title => "card one")
    @card.reload
    @card.card_state = @card_state
    @card.card_state.should == @card_state
    @card_state.destroy
    @card.reload
    @card.card_state.should == nil
  end
  
end
