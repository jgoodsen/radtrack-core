require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  
  before(:each) do
    @user = User.create_admin_user
  end

  describe "name attribute fallback" do
    it "use name if it exists" do
      @user.update_attributes(:name => "mary")
      @user.name.should == "mary"
    end
    it "use login if name does not exist" do
      @user.name.should == "Administrator"
    end
  end  

  describe 'login is always the email address' do
    it "should assign email to the login when update_attributes is called" do
      @user.update_attributes(:email => 'joe@blow.com')
      @user.login.should == 'joe@blow.com'
    end
  end
  
end
