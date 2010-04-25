require File.dirname(__FILE__) + '/../spec_helper'
require 'rubygems'

describe Project do
  
  before(:each) do
    @project = Factory(:project)
  end
 
  describe 'saving a project' do
  
    it 'should require a non-blank name' do
      project = Project.new({:name => ''})
      project.save.should be_false
      project.name = "X"
      project.save.should be_true
    end
  
  end

  describe "create" do
    
    it "should have a default task state" do
      ## TODO: Revisit if this even makes sense?  Perhaps task states should be type conformant with activites in a workflow ?
      @project.default_task_state.should_not be_nil
    end
    
    it "should have a default workflow" do
      @project.save!
      # @project.workflow.should_not be_nil
    end
  end
      
  describe "card_states" do
    
    it 'a new project should setup a default set of card_states' do
      project = Project.new(:name => 'Test Project')
      project.card_states.should be_empty
      project.save!
      project.card_states.size.should > 0
    end

    it 'should acts_as_list' do

      def set_order(state, order)
        state.position = order
        state.save!
      end
      
      @project = Project.new :name => 'Test Project'
      @project.card_states.size.should == 0
      @project.save!
      @project.save!
      @project.card_states.size.should == 4     
      
      old_order = @project.card_states.collect
      
      set_order(@project.card_states[0], 2)
      set_order(@project.card_states[1], 0)
      set_order(@project.card_states[2], 3)
      set_order(@project.card_states[3], 1)
      
      @project.card_states.reload
      
      # old_order[0].should == @project.card_states[2]
      old_order[1].should == @project.card_states[0]
      old_order[2].should == @project.card_states[3]
      old_order[3].should == @project.card_states[1]

    end
    
  end
  
  describe 'destroy' do
    
    before(:each) do
      # clean_all_project_tables
      Project.delete_all
      CardState.delete_all
      Card.delete_all
      CardType.init
      @project = Factory(:project)
      @project.save!
      @project.card_states.should_not be_empty
    end

    it "should destroy the CardState model for the project" do
      @project.destroy
      CardState.all.should be_empty
    end
    
    it "should destroy all cards" do
      @project.cards.create
      Card.all.should_not be_empty
      @project.destroy
      Card.all.should be_empty
    end
    
  end

  describe "cards" do
    
    describe "should acts_as_list" do
      it "should retain the saved state" do
        @project.cards = []

        @project.save!
        card1 = @project.cards.create(:title => "card one")
        card2 = @project.cards.create(:title => "card two")

        @project.save!
        (card1.position < card2.position).should be_true
        
        @project.save!
        
        @project.reload
        @project.cards[0].should == card1
        
        @project.cards = [card2, card1]
        @project.save!
        
        @project.reload
        
        card2.remove_from_list
        card2.insert_at 1
        card2.move_to_bottom

        card1.remove_from_list
        card1.insert_at 1
        card1.move_to_bottom

        @project.cards[0].should == card2
        
        card2.move_to_bottom
        @project.reload
        @project.cards[0].should == card1
        
      end
    end
  end

  describe "a project with some users" do
    
    before(:each) do
      @project.users = []
      @normal_user = Factory.build(:user)
      @admin_user = Factory.build(:user)
      @admin_user.admin = true
      @project.users << @normal_user
      @project.users << @admin_user
    end

    describe "project owners" do
      it "should include all project users associated with the project until we implement finer grained security" do
        @project.owners.should == @project.users
      end
    end

    describe "remove_user" do

      it "should never delete the last admin user for a project - there must always be at least on administrator of a project." do
        lambda {@project.remove_user(@admin_user)}.should raise_error(RuntimeError)
        @project.users.size.should == 2
      end
      
      it "should work otherwise" do
        @project.remove_user(@normal_user)
        @project.users.size.should == 1
      end
      
      it "should remove the user association to any tasks in the project" do
        @card = @project.cards.create(:title => 'test card')
        @task = @card.tasks.create(:name => 'test task')
        @normal_user.tasks << @task
        @project.remove_user(@normal_user)
        @normal_user.tasks.include?(@task).should be_false
      end

    end
    
  end
    
end
