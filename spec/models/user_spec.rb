require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  before(:each) do
    @user = User.create_admin_user
  end

  describe "Password requirements" do
    it "should require a password and password confirmation" do
      @user = User.new(user.without(:password, :password_confirmation))
      @user.should have(1).error_on(:password)
      @user.should have(1).error_on(:password_confirmation)
    end

    it "should require matching password and confirmation" do
      @user = User.new(user.with(:password_confirmation => 'different password'))
      @user.should have(1).error_on(:password)
    end

    it "should require at least 6 digit password" do
      @user = User.new(user.with(:password => 'short', :password_confirmation => 'short'))
      @user.should have(1).error_on(:password)
    end
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

  private
  def user
    user_attributes = {
      :login => 'admin', 
      :email => 'admin@radtrack.com', 
      :password => 'monkey', 
      :password_confirmation => 'monkey', 
      :name => 'Administrator', 
      :admin => 1
    }

    user_attributes.class_eval do
      def without(*fields)
        fields.each { | field | self.delete field }
        self
      end

      def with(fields)
        self.merge(fields)
      end
    end

    user_attributes
  end
end