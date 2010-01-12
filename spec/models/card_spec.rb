require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Card do
  
  before(:each) do
    @project = Project.create!(:name =>'Test Project')
  end

  describe "after creation" do

    before(:each) do
      @card =  @project.cards.create!(:title => "my card")
    end

  end
  
  describe 'card invariant' do
    it "should always be associated with a project" do
      @card = Card.new(:project => @project)
      @card.save.should == true      
      @card.project = nil
      @card.save.should == false
      @card.errors[:project] == "A Card must always belong to a project"
    end   
    
  end
  
  describe 'deleting a card' do
    it "should delete all of it's tasks'" do
      @card =  Card.create(:project => @project)
      Task.count.should == 0
      task = @card.tasks.create!(:name => 'test task')
      Task.count.should == 1
      @card.destroy
      Task.count.should == 0
    end
  end

  describe "handling card owner" do
    before(:each) do
      @card = Card.create(:project => @project)
    end

    it "provide unassigned mock owner if not assigned yet" do
      @card.owner.name.should == "Owner is unassigned"
    end

    it "use user if exists for owner" do
      @card.owner = User.create_admin_user
      @card.save!
      @card.owner.name.should == "Administrator"
    end
  end

  describe "finding user cards by project" do
    before(:each) do
      @card1 = Card.create(:project => @project)
      @user = User.create_guest_user
      @user.cards << @card1      
    end

    it "find cards for user" do
      @user.cards.by_project(@project).should == [@card1]
    end

    it "be able to get correct cards even if user is in more than one project" do
      project2 = Project.create!(:name =>'Another Project')
      card2 = Card.create(:project => project2)
      @user.cards << card2
      @user.cards.by_project(@project).should == [@card1]
      @user.cards.by_project(project2).should == [card2]
    end

    describe "activate" do
      it "should set the card_state the first card_state of the project" do
        @card = Card.create(:project => @project)
        @card.move_to_backlog
        @card.card_state.should == nil
        @card.activate!
        @card.card_state.should == @card.project.card_states.first
      end
    end   

  end
  
end
