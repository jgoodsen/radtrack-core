require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Task do

    describe('to json') do
    
      it('should include the username') {
        user = User.new(:login => "hi stem")
        task = Task.new()
        task.user = user
        user.tasks << task
        user.tasks.size.should == 1
        task.user.should == user
        task.to_json.should =~ /\"username\":\"hi stem\"/
      }
      
    end
    
end
