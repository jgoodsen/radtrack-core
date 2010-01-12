require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CardState do
  
  it "should only allow alphanumerics, spaces and dashs for name"
  it "should enforce a limit to the name length"
  it "should not let the name be empty"

  it "all cards that used to have this state, should have null for their cardstate after the cardstate is removed" do
    @project = Factory(:project)
    @card_state = @project.card_states.create(:name => "ActivityOne")
    @card = @project.cards.create(:title => "card one")
    @card_state.cards << @card
    @card.reload
    @card.card_state.should == @card_state
    @card_state.destroy
    @card.reload
    @card.card_state.should == nil
  end
  
end
